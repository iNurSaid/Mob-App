import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'hasil_extraction_screen.dart';

class ExtractionListScreen extends StatelessWidget {
  const ExtractionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> extractionList = List.generate(10, (
      index,
    ) {
      return {
        'image': 'assets/Watermark_${index + 1}.png',
        'watermark': 'SWT-QR-SS',
        'subband': 4,
        'bit': 16,
        'alfass': index % 2 == 0 ? '0.5' : 'DL-Auto',
      };
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5E8E4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFD1512D)),
        title: const Text(
          'Extraction List',
          style: TextStyle(
            color: Color(0xFF411530),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: GridView.builder(
          itemCount: extractionList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final item = extractionList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => HasilExtractionScreen(
                          imagePath: item['image'],
                          watermark: item['watermark'],
                          subband: item['subband'],
                          bit: item['bit'],
                          alfass: item['alfass'],
                        ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/history'),
    );
  }
}
