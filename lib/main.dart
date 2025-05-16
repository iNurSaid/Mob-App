import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'embeding_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'extraction_screen.dart';
import 'library_screen.dart';
import 'audio_screen.dart';
import 'image_screen.dart';
import 'embeding_list_screen.dart';
import 'extraction_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WaveMark App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5E8E4),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/embed': (context) => const EmbedingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const HistoryScreen(),
        '/extract': (context) => const ExtractionScreen(),
        '/library': (context) => const LibraryScreen(),
        '/library_audio': (context) => const AudioScreen(),
        '/library_image': (context) => const ImageScreen(),
        '/embedding_list': (context) => const EmbeddingAudioListScreen(),
        '/extraction_list': (context) => const ExtractionListScreen(),
      },
    );
  }
}
