import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'bottom_nav.dart';

class HasilEmbeddingScreen extends StatefulWidget {
  final int currentIndex;
  final List<Map<String, dynamic>> embeddingList;

  const HasilEmbeddingScreen({
    Key? key,
    required this.currentIndex,
    required this.embeddingList,
  }) : super(key: key);

  @override
  State<HasilEmbeddingScreen> createState() => _HasilEmbeddingScreenState();
}

class _HasilEmbeddingScreenState extends State<HasilEmbeddingScreen> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  Map<String, dynamic> get currentTrack =>
      widget.embeddingList[widget.currentIndex];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _player.setAudioSource(AudioSource.asset(currentTrack['file']));
      _player.playerStateStream.listen((state) {
        if (mounted) setState(() => _isPlaying = state.playing);
      });
      _player.durationStream.listen((d) {
        if (d != null && mounted) setState(() => _duration = d);
      });
      _player.positionStream.listen((pos) {
        if (mounted) setState(() => _position = pos);
      });
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _cleanUpAudio();
    super.dispose();
  }

  Future<void> _cleanUpAudio() async {
    try {
      await _player.stop();
      await _player.dispose();
    } catch (e) {
      print("Dispose error: $e");
    }
  }

  void navigateToTrack(int newIndex) async {
    if (newIndex >= 0 && newIndex < widget.embeddingList.length) {
      await _player.stop();
      await _player.dispose();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => HasilEmbeddingScreen(
                currentIndex: newIndex,
                embeddingList: widget.embeddingList,
              ),
        ),
      );
    }
  }

  void showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFFF3EDF7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Penjelasan SNR & ODG"),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• SNR (Signal-to-Noise Ratio): mengukur rasio kualitas sinyal terhadap noise. Semakin tinggi nilainya, semakin baik kualitas audio.",
                ),
                SizedBox(height: 8),
                Text(
                  "• ODG (Objective Difference Grade): menilai perbedaan sinyal asli dan hasil embedding. ODG mendekati 0 berarti perbedaan tidak terdengar, -4 sangat terdengar.",
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Tutup",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8E4),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFD1512D)),
        title: const Text(
          'Hasil Embeding',
          style: TextStyle(
            color: Color(0xFF411530),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF3F0D1C)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF3F0D1C)),
            onPressed: showHelpDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentTrack['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            Text(
              currentTrack['artist'],
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Slider(
              activeColor: Colors.deepOrange,
              inactiveColor: Colors.black26,
              value: _position.inSeconds.toDouble().clamp(
                0.0,
                _duration.inSeconds.toDouble(),
              ),
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) async {
                final newPosition = Duration(seconds: value.toInt());
                await _player.seek(newPosition);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDuration(_position)),
                Text(formatDuration(_duration)),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 40,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () => navigateToTrack(widget.currentIndex - 1),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 56,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () async {
                      if (_isPlaying) {
                        await _player.pause();
                      } else {
                        await _player.play();
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      size: 40,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () => navigateToTrack(widget.currentIndex + 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3F0D1C), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Metode: ${currentTrack['watermark']}'),
                  Text(
                    'Subband: ${currentTrack['subband'] ?? '-'} | Bit: ${currentTrack['bit'] ?? '-'} | Alpha: ${currentTrack['alfass']}',
                  ),
                  Text(
                    'SNR: ${currentTrack['snr']?.toStringAsFixed(2) ?? '-'} dB | ODG: ${currentTrack['odg']?.toStringAsFixed(2) ?? '-'}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/history'),
    );
  }
}
