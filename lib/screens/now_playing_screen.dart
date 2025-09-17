import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';

class NowPlayingScreen extends StatelessWidget {
  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Obx(() {
        if (musicController.currentSong.value == null) {
          return Center(
            child: Text(
              'No song playing',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        final song = musicController.currentSong.value!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green.withOpacity(0.3),
                Color(0xFF121212),
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down, 
                                 color: Colors.white, size: 30),
                        onPressed: () => Get.back(),
                      ),
                      Text(
                        'Now Playing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Album Art with Hero Animation
                Hero(
                  tag: 'album-art-${song.id}-player', // Match the player tag
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        musicController.getBestThumbnail(song),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: Icon(Icons.music_note, color: Colors.grey, size: 100),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Song Info
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        song.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        song.author,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // Progress Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Obx(() {
                        return SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.green,
                            overlayColor: Colors.green.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: musicController.position.value.inSeconds.toDouble(),
                            max: musicController.duration.value.inSeconds.toDouble(),
                            onChanged: (value) {
                              musicController.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                              musicController.formatDuration(musicController.position.value),
                              style: TextStyle(color: Colors.grey[400]),
                            )),
                            Obx(() => Text(
                              musicController.formatDuration(musicController.duration.value),
                              style: TextStyle(color: Colors.grey[400]),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Controls
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shuffle, color: Colors.grey[400], size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white, size: 40),
                        onPressed: () {},
                      ),
                      // Play/Pause Button with Animation
                      Obx(() {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: Icon(
                                musicController.isPlaying.value 
                                    ? Icons.pause 
                                    : Icons.play_arrow,
                                key: ValueKey(musicController.isPlaying.value),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            onPressed: musicController.togglePlayPause,
                          ),
                        );
                      }),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white, size: 40),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.repeat, color: Colors.grey[400], size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
