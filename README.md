# 🎵 Awesome Music Streaming App

A beautiful, cross-platform music streaming application built with Flutter that delivers an exceptional user experience with stunning animations and seamless audio playback.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Web](https://img.shields.io/badge/Web-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white)

## ✨ Features

### 🎶 Core Music Features
- **Real-time Music Search** - Search millions of songs from YouTube Music
- **High-Quality Audio Streaming** - Crystal clear audio playback with smart stream selection
- **Beautiful Now Playing Screen** - Full-screen player with album art and controls
- **Smart Playlist Management** - Create and manage your favorite playlists
- **Background Audio Support** - Keep music playing even when app is minimized

### 🎨 Stunning UI/UX
- **Dark Theme Design** - Easy on the eyes, perfect for music listening
- **Hero Animations** - Smooth transitions between screens with album art
- **Micro-interactions** - Delightful animations that respond to user actions
- **Responsive Design** - Optimized for phones, tablets, and desktop
- **Material Design 3** - Modern, clean interface following latest design guidelines

### ⚡ Performance & Optimization
- **Debounced Search** - Intelligent search that reduces API calls
- **Image Caching** - Fast loading album artwork with fallbacks
- **Memory Management** - Efficient resource usage for smooth performance
- **Cross-Platform** - Single codebase for Android, iOS, and Web

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.22.0)
- Dart SDK (>=3.9.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
git clone https://github.com/NjadG99/awesome-music-streaming-app.git

cd awesome-music-streaming-app


2. **Install dependencies**
flutter pub get


3. **Run the app**
    For Android
        flutter run

    For iOS
        flutter run -d ios

    For Web
        flutter run -d chrome


## 🛠️ Built With

### Core Technologies
- **[Flutter](https://flutter.dev/)** - UI framework for cross-platform development
- **[Dart](https://dart.dev/)** - Programming language optimized for UI development
- **[GetX](https://pub.dev/packages/get)** - State management and navigation

### Audio & Media
- **[just_audio](https://pub.dev/packages/just_audio)** - High-performance audio player
- **[media_kit](https://pub.dev/packages/media_kit)** - Audio player for desktop platforms
- **[audio_service](https://pub.dev/packages/audio_service)** - Background audio and media controls
- **[youtube_explode_dart](https://pub.dev/packages/youtube_explode_dart)** - YouTube metadata and stream extraction

### Data & Storage
- **[hive](https://pub.dev/packages/hive)** - Fast, lightweight local database
- **[hive_flutter](https://pub.dev/packages/hive_flutter)** - Flutter integration for Hive
- **[http](https://pub.dev/packages/http)** - HTTP client for API requests

### UI Enhancements
- **[cached_network_image](https://pub.dev/packages/cached_network_image)** - Optimized network image loading

## 📁 Project Structure

    lib/
    ├── controllers/ # GetX controllers for state management
    │ └── music_controller.dart
    ├── screens/ # UI screens
    │ ├── search_screen.dart
    │ └── now_playing_screen.dart
    ├── models/ # Data models
    ├── services/ # API services and utilities
    ├── widgets/ # Reusable UI components
    └── main.dart # App entry point


## 🎯 Key Features Explained

    ### Smart Audio Streaming
    The app uses `youtube_explode_dart` to extract high-quality audio streams from YouTube, automatically selecting the best available bitrate for optimal listening experience.

    ### Beautiful Animations
    - **Hero Animations** - Album artwork smoothly transitions between screens
    - **Micro-interactions** - Play/pause buttons with satisfying state changes
    - **Loading States** - Elegant loading indicators throughout the app

    ### Performance Optimizations
    - **Debounced Search** - Prevents excessive API calls during typing
    - **Image Optimization** - Smart fallbacks for missing thumbnails
    - **Memory Management** - Proper disposal of resources to prevent memory leaks


## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For creating an amazing cross-platform framework
- **YouTube Music** - For providing the music catalog
- **Open Source Community** - For the incredible packages that made this possible
- **Material Design** - For the beautiful design system

---

## ⭐ Show Your Support

If you found this project helpful, please give it a ⭐ on GitHub!

---

## 🔧 Development Notes

### Network Issues
If you encounter network connectivity issues on physical devices, ensure your internet connection is stable and try switching between WiFi and mobile data.

### Platform Support
- ✅ **Android** - Full functionality with YouTube integration
- ✅ **iOS** - Complete feature set (requires Mac for development)
- ✅ **Web** - UI development and testing (limited YouTube API access due to CORS)

### Performance Tips
- Use Android emulator for full YouTube Music integration during development
- Test on physical devices for optimal performance evaluation
- Web version is perfect for showcasing UI/UX and animations

---

*Built with passion for music lovers everywhere! 🎵*
