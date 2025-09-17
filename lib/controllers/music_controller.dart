import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final YoutubeExplode _ytExplode = YoutubeExplode();

  var currentSong = Rxn<Video>();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    _audioPlayer.playingStream.listen((playing) {
      isPlaying.value = playing;
    });

    _audioPlayer.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });

    _audioPlayer.positionStream.listen((p) {
      position.value = p;
    });
  }

  String getBestThumbnail(Video video) {
    // Try different thumbnail qualities in order
    try {
      return video.thumbnails.highResUrl;
    } catch (e) {
      try {
        return video.thumbnails.mediumResUrl;
      } catch (e) {
        return video.thumbnails.lowResUrl;
      }
    }
  }

  Future<void> playYouTubeVideo(Video video) async {
    try {
      isLoading.value = true;
      currentSong.value = video;

      // Select best audio stream (highest bitrate)
      var manifest = await _ytExplode.videos.streamsClient.getManifest(video.id);
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();

      if (audioStreamInfo != null) {
        await _audioPlayer.setUrl(audioStreamInfo.url.toString());
        await _audioPlayer.play();

        Get.snackbar(
          '🎵 Now Playing',
          video.title,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to play: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void stop() {
    _audioPlayer.stop();
    currentSong.value = null;
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _ytExplode.close();
    super.onClose();
  }
}
