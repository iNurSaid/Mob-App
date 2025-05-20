import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'embedding_result_screen.dart';
import 'audio_screen.dart';
import 'image_screen.dart';

class EmbedingScreen extends StatefulWidget {
  const EmbedingScreen({super.key});

  @override
  State<EmbedingScreen> createState() => _EmbedingScreenState();
}

class _EmbedingScreenState extends State<EmbedingScreen> {
  String? selectedWatermark;
  int? selectedSubband;
  int? selectedBit;
  String alfass = '';
  String? selectedImagePath;
  String? selectedAudioPath;

  final watermarkOptions = [
    'SWT-DST-QR-SS',
    'SWT-DCT-QR-SS',
    'DWT-DST-SVD-SS',
    'DWT-DCT-SVD-SS',
  ];
  final subbandOptions = [1, 2, 3, 4];
  final bitOptions = [16, 32];

  void onUpload(String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text("Ambil dari Device"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fitur belum tersedia.")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Pilih dari Library"),
              onTap: () async {
                Navigator.pop(context);
                final selectedFile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            type == "Audio"
                                ? const AudioScreen(isPicker: true)
                                : const ImageScreen(isPicker: true),
                  ),
                );

                if (selectedFile != null && selectedFile is String) {
                  setState(() {
                    if (type == "Image") {
                      selectedImagePath = selectedFile;
                    } else {
                      selectedAudioPath = selectedFile;
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
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

  void onStartEmbedding() {
    if (selectedWatermark != null &&
        selectedSubband != null &&
        selectedBit != null &&
        alfass.isNotEmpty) {
      if (selectedImagePath == null || selectedAudioPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select image and audio from library"),
          ),
        );
        return;
      }

      showLoadingThenNavigate(
        context: context,
        nextPage: EmbeddingResultScreen(
          watermark: selectedWatermark!,
          subband: selectedSubband!,
          bit: selectedBit!,
          alfass: alfass,
          imagePath: selectedImagePath!,
          audioPath: selectedAudioPath!,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all parameters.")),
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
          'Embedding',
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
                      title: const Text("Penjelasan Parameter"),
                      content: const Text(
                        "🔸 Subband: bagian frekuensi tempat watermark disisipkan.\n"
                        "🔸 Bit: panjang bit watermark (misal 16-bit atau 32-bit).\n"
                        "🔸 Alpha: kekuatan penyisipan watermark (semakin besar, semakin kuat namun bisa mempengaruhi kualitas audio).",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUploadSection(
                "Select Image",
                Icons.image,
                () => onUpload("Image"),
                selectedImagePath != null
                    ? selectedImagePath!.split("/").last
                    : null,
              ),
              const SizedBox(height: 20),
              buildUploadSection(
                "Select Audio",
                Icons.headphones,
                () => onUpload("Audio"),
                selectedAudioPath != null
                    ? selectedAudioPath!.split("/").last
                    : null,
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
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 24),
              _buildDropdown("Subband", selectedSubband, subbandOptions, (val) {
                setState(() => selectedSubband = val);
              }),
              const SizedBox(height: 20),
              _buildDropdown("Bit", selectedBit, bitOptions, (val) {
                setState(() => selectedBit = val);
              }),
              const SizedBox(height: 20),
              const Text(
                "Alfass",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF411530),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (val) => alfass = val,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration().copyWith(
                  hintText: "Enter alfass value",
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: ElevatedButton(
                  onPressed: onStartEmbedding,
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
                    'Start Embedding',
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
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/upload'),
    );
  }

  Widget buildUploadSection(
    String label,
    IconData icon,
    VoidCallback onTap,
    String? selectedFileName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF411530),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
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
                Text(
                  selectedFileName ?? 'Select file',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF411530), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    int? selectedValue,
    List<int> options,
    ValueChanged<int?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF411530),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedValue,
          hint: Text("Select $label"),
          items:
              options
                  .map(
                    (val) => DropdownMenuItem(
                      value: val,
                      child: Text(val.toString()),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }
}
