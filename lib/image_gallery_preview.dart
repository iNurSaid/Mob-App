import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class ImageGalleryPreview extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const ImageGalleryPreview({
    super.key,
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryPreview> createState() => _ImageGalleryPreviewState();
}

class _ImageGalleryPreviewState extends State<ImageGalleryPreview> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  void _handleDownloadStub() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Download feature is disabled")),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Delete Image"),
            content: const Text("This image will be deleted. Continue?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xFFD1512D)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close preview
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Image deleted")),
                  );
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CloseButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _handleDownloadStub,
            icon: const Icon(Icons.download, color: Colors.white),
          ),
          IconButton(
            onPressed: _showDeleteConfirmation,
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        onPageChanged: (index) => setState(() => currentIndex = index),
        itemBuilder: (context, index) {
          final imagePath = widget.imagePaths[index];
          return InteractiveViewer(
            child: Center(child: Image.asset(imagePath, fit: BoxFit.contain)),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/library_images'),
    );
  }
}
