import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class EmbeddingResultScreen extends StatelessWidget {
  final String watermark;
  final int subband;
  final int bit;
  final String alfass;

  const EmbeddingResultScreen({
    super.key,
    required this.watermark,
    required this.subband,
    required this.bit,
    required this.alfass,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDL = alfass == "DL-Auto";

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
            const Text(
              'Inside Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD1512D),
              ),
            ),
            const Text(
              'The Chainsmokers, Cha...',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Text('0:25'),
                Expanded(
                  child: Slider(
                    value: 25,
                    min: 0,
                    max: 195,
                    onChanged: null,
                    activeColor: Color(0xFF411530),
                  ),
                ),
                Text('3:15'),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFD1512D),
                child: const Icon(
                  Icons.play_arrow,
                  size: 30,
                  color: Colors.white,
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
                "Metode: $watermark\n"
                "Subband: ${isDL ? '-' : subband} | Bit: ${isDL ? '-' : bit} | Alpha: $alfass\n"
                "SNR: 32.63 dB | ODG: -3.43\n"
                "Status: Watermark berhasil diekstraksi.",
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
