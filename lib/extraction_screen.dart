import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'extraction_result_screen.dart';

class ExtractionScreen extends StatefulWidget {
  const ExtractionScreen({super.key});

  @override
  State<ExtractionScreen> createState() => _ExtractionScreenState();
}

class _ExtractionScreenState extends State<ExtractionScreen> {
  String? selectedWatermark;
  bool useDeepLearning = false;

  final watermarkOptions = ['Metode 1', 'Metode 2', 'Metode 3', 'Metode 4'];

  void onUploadAudio() {
    debugPrint('Audio uploaded for extraction');
  }

  void onUploadKey() {
    debugPrint('Key file uploaded');
  }

  Future<void> showLoadingThenNavigate({
    required BuildContext context,
    required Widget nextPage,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: Color(0xFFD1512D)),
          ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => nextPage));
  }

  void onStartExtraction() {
    if (selectedWatermark == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih Metode terlebih dahulu.")),
      );
    } else {
      showLoadingThenNavigate(
        context: context,
        nextPage: ExtractionResultScreen(
          imagePath: 'assets/C2.png',
          watermark: selectedWatermark!,
          subband: 2,
          bit: 16,
          alfass: '0.002',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8E4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFD1512D)),
        title: const Text(
          'Extraction',
          style: TextStyle(
            color: Color(0xFF411530),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF411530)),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Penjelasan Ekstraksi"),
                      content: const Text(
                        "🔸 Untuk proses ekstraksi, pengguna cukup memberikan file audio yang telah ter-watermark beserta kunci parameter.\n\n"
                        "🔸 Sistem akan memprosesnya dan mengembalikan hasil berupa citra watermark serta nilai performa sistem seperti akurasi atau kesalahan ekstraksi.",
                        style: TextStyle(fontSize: 14),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Audio for Extraction",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF411530),
              ),
            ),
            const SizedBox(height: 8),
            _buildUploadBox(
              icon: Icons.headphones,
              label: 'Select audio file',
              onTap: onUploadAudio,
            ),
            const SizedBox(height: 20),
            const Text(
              "Upload Key File",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF411530),
              ),
            ),
            const SizedBox(height: 8),
            _buildUploadBox(
              icon: Icons.vpn_key,
              label: 'Select key file',
              onTap: onUploadKey,
            ),
            const SizedBox(height: 30),
            const Text(
              "Select Metode",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF411530),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedWatermark,
              hint: const Text("Choose Metode"),
              items:
                  watermarkOptions
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedWatermark = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF411530),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Use Deep Learning",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF411530),
                  ),
                ),
                Switch(
                  value: useDeepLearning,
                  activeColor: const Color(0xFFD1512D),
                  onChanged: (val) => setState(() => useDeepLearning = val),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Center(
              child: ElevatedButton(
                onPressed: onStartExtraction,
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
                  'Start Extraction',
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
      bottomNavigationBar: const BottomNavBar(currentRoute: '/extract'),
    );
  }

  Widget _buildUploadBox({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: const Color(0xFF411530), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
