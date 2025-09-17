import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:async';
import '../controllers/music_controller.dart';
import 'now_playing_screen.dart';

class SearchController extends GetxController {
  var searchResults = <Video>[].obs;
  var isLoading = false.obs;
  final yt = YoutubeExplode();
  Timer? _debounceTimer;

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Add debouncing - wait 500ms before searching
    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      isLoading.value = true;
      
      try {
        var searchResult = await yt.search.search('$query music');
        searchResults.value = searchResult.take(20).toList();
      } catch (e) {
        Get.snackbar('Error', 'Failed to search: $e');
      } finally {
        isLoading.value = false;
      }
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    yt.close();
    super.onClose();
  }
}

class SearchScreen extends StatelessWidget {
  final SearchController controller = Get.put(SearchController());
  final MusicController musicController = Get.put(MusicController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔍 Search Music'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: textController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for songs, artists...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Color(0xFF282828),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                controller.searchSongs(value);
              },
              onSubmitted: (value) {
                controller.searchSongs(value);
              },
            ),
          ),
          
          // Search Results
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'Searching for music...',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.music_note, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Search for your favorite music!',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try searching for artists, songs, or albums',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: controller.searchResults.length,
                cacheExtent: 200, // Performance optimization
                itemBuilder: (context, index) {
                  final video = controller.searchResults[index];
                  return Card(
                    color: Color(0xFF282828),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: Hero(
                        tag: 'album-art-${video.id}-search', // Unique tag
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            musicController.getBestThumbnail(video),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[800],
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / 
                                        loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: Colors.green,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[800],
                                child: Icon(Icons.music_note, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        video.title,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.author,
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 2),
                          Text(
                            video.duration?.toString() ?? 'Unknown duration',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Obx(() {
                        bool isCurrentSong = musicController.currentSong.value?.id == video.id;
                        return IconButton(
                          icon: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            child: Icon(
                              isCurrentSong && musicController.isPlaying.value 
                                  ? Icons.pause 
                                  : Icons.play_arrow,
                              key: ValueKey('${isCurrentSong}-${musicController.isPlaying.value}'),
                              color: isCurrentSong ? Colors.green : Colors.grey[400],
                              size: 30,
                            ),
                          ),
                          onPressed: () {
                            if (isCurrentSong && musicController.currentSong.value != null) {
                              // If same song is playing, go to now playing screen
                              Get.to(() => NowPlayingScreen());
                            } else {
                              // If different song or no song playing, start playing
                              musicController.playYouTubeVideo(video);
                            }
                          },
                        );
                      }),
                      onTap: () {
                        // Tap anywhere on the tile to play the song
                        musicController.playYouTubeVideo(video);
                      },
                    ),
                  );
                },
              );
            }),
          ),
          
          // Now Playing Bar at Bottom
          Obx(() {
            if (musicController.currentSong.value != null) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => NowPlayingScreen());
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    border: Border(
                      top: BorderSide(color: Colors.grey[800]!, width: 0.5),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'album-art-${musicController.currentSong.value!.id}-player', // Unique tag
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            musicController.getBestThumbnail(musicController.currentSong.value!),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[800],
                                child: Icon(Icons.music_note, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              musicController.currentSong.value!.title,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              musicController.currentSong.value!.author,
                              style: TextStyle(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (musicController.isLoading.value) {
                          return CircularProgressIndicator(color: Colors.green, strokeWidth: 2);
                        }
                        return IconButton(
                          icon: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            child: Icon(
                              musicController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                              key: ValueKey(musicController.isPlaying.value),
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          onPressed: musicController.togglePlayPause,
                        );
                      }),
                    ],
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
