import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/search_screen.dart';
import 'package:flutter/foundation.dart';

// holaa hii fuck you

void main() {
  // Only show debug info in debug mode
  if (kDebugMode) {
    print('Debug mode - showing all logs');
  }
  
  runApp(AwesomeMusicApp());
}


class AwesomeMusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Awesome Music App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFF121212),
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎵 Awesome Music'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Your Amazing Music App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            
            // Updated button to navigate to search
            ElevatedButton(
              onPressed: () {
                Get.to(() => SearchScreen());
              },
              child: Text('🔍 Search Music'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
