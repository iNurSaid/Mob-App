import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'bottom_nav.dart';

class EmbeddingResultScreen extends StatefulWidget {
  final String watermark;
  final int subband;
  final int bit;
  final String alfass;
  final String imagePath;
  final String audioPath;

  const EmbeddingResultScreen({
    super.key,
    required this.watermark,
    required this.subband,
    required this.bit,
    required this.alfass,
    required this.imagePath,
    required this.audioPath,
  });

  @override
  State<EmbeddingResultScreen> createState() => _EmbeddingResultScreenState();
}

class _EmbeddingResultScreenState extends State<EmbeddingResultScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String audioTitle = "Unknown Title";
  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadAudio();
    _extractAudioTitle();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  void _extractAudioTitle() {
    final parts = widget.audioPath.split("/");
    final filename = parts.isNotEmpty ? parts.last : "";
    final name = filename.replaceAll(".wav", "").replaceAll("_", "-");
    setState(() {
      audioTitle = name;
    });
  }

  Future<void> _loadAudio() async {
    try {
      final bytes = await rootBundle.load(widget.audioPath);
      final audioData = bytes.buffer.asUint8List();
      final uri = Uri.dataFromBytes(audioData);
      await _audioPlayer.setAudioSource(AudioSource.uri(uri));
      await _audioPlayer.load();
      final duration = _audioPlayer.duration;
      if (duration != null) {
        setState(() {
          audioDuration = duration;
        });
      }
    } catch (e) {
      debugPrint("Audio load error: $e");
    }
  }

  void _togglePlayback() {
    setState(() => isPlaying = !isPlaying);
    isPlaying ? _audioPlayer.play() : _audioPlayer.pause();
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDL = widget.alfass == "DL-Auto";

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
            icon: const Icon(
              Icons.file_download_outlined,
              color: Color(0xFF411530),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Download function not implemented yet."),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF411530)),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Penjelasan SNR & ODG"),
                      content: const Text(
                        "🔸 SNR (Signal-to-Noise Ratio): mengukur rasio kualitas sinyal terhadap noise. "
                        "Semakin tinggi nilainya, semakin baik kualitas audio.\n\n"
                        "🔸 ODG (Objective Difference Grade): menilai perbedaan sinyal asli dan hasil embedding. "
                        "ODG mendekati 0 berarti perbedaan tidak terdengar, -4 sangat terdengar.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Tutup"),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              audioTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD1512D),
              ),
            ),
            const Text(
              'Audio Watermarking',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(formatDuration(currentPosition)),
                Expanded(
                  child: Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: audioDuration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final newPos = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(newPos);
                    },
                    activeColor: const Color(0xFF411530),
                  ),
                ),
                Text(formatDuration(audioDuration)),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _togglePlayback,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFD1512D),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0xFF411530), width: 1.5),
              ),
              child: Text(
                "Metode: ${widget.watermark}\n"
                "Subband: ${isDL ? '-' : widget.subband} | Bit: ${isDL ? '-' : widget.bit} | Alpha: ${widget.alfass}\n"
                "SNR: 20.66 dB | ODG: -3.43\n"
                "Status: Watermark berhasil diembeding.",
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Color(0xFF411530),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            "Lanjutkan ke Ekstraksi?",
                            style: TextStyle(
                              color: Color(0xFF411530),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            "Apakah kamu sudah mendownload audio hasil embedding?\n"
                            "Proses ekstraksi memerlukan audio tersebut.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Tidak"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/extract');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD1512D),
                              ),
                              child: const Text(
                                "Ya",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD1512D),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Ekstraksi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/upload'),
    );
  }
}
