import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'embedding_result_screen.dart';

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
  bool useDeepLearning = false;

  final watermarkOptions = ['Metode 1', 'Metode 2', 'Metode 3', 'Metode 4'];
  final subbandOptions = [1, 2, 3, 4];
  final bitOptions = [16, 32];

  void onUpload(String type) {
    debugPrint('Upload $type file...');
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
        (useDeepLearning ||
            (selectedSubband != null &&
                selectedBit != null &&
                alfass.isNotEmpty))) {
      showLoadingThenNavigate(
        context: context,
        nextPage: EmbeddingResultScreen(
          watermark: selectedWatermark!,
          subband: selectedSubband ?? -1,
          bit: selectedBit ?? -1,
          alfass: useDeepLearning ? "DL-Auto" : alfass,
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
                "Upload Image",
                Icons.image,
                () => onUpload("Image"),
              ),
              const SizedBox(height: 20),
              buildUploadSection(
                "Upload Audio",
                Icons.headphones,
                () => onUpload("Audio"),
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

              const SizedBox(height: 12),
              _buildDropdown("Subband", selectedSubband, subbandOptions, (val) {
                setState(() => selectedSubband = val);
              }, enabled: !useDeepLearning),

              const SizedBox(height: 20),
              _buildDropdown("Bit", selectedBit, bitOptions, (val) {
                setState(() => selectedBit = val);
              }, enabled: !useDeepLearning),

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
                enabled: !useDeepLearning,
                onChanged: (val) => alfass = val,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration().copyWith(
                  hintText: "Enter alfass value",
                  fillColor:
                      useDeepLearning ? Colors.grey.shade200 : Colors.white,
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

  Widget buildUploadSection(String label, IconData icon, VoidCallback onTap) {
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
                const Text('Select file', style: TextStyle(color: Colors.grey)),
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
    ValueChanged<int?> onChanged, {
    bool enabled = true,
  }) {
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
          onChanged: enabled ? onChanged : null,
          decoration: _inputDecoration().copyWith(
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}
