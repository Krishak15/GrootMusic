import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:grootmusic/models/art_provider.dart';
import 'package:grootmusic/views/home_screen.dart';
import 'package:grootmusic/views/playlists_screen.dart';
import 'package:grootmusic/views/songs_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ArtProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groot Music',
      theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white)),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        // GetPage(name: '/songs', page: () => SongsScreen()),
        GetPage(name: '/playlists', page: () => const PlayList()),
      ],
    );
  }
}
