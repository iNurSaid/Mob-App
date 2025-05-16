import 'package:flutter/material.dart';
import 'hasil_embeding_screen.dart';
import 'bottom_nav.dart';

class EmbeddingAudioListScreen extends StatefulWidget {
  const EmbeddingAudioListScreen({super.key});

  @override
  State<EmbeddingAudioListScreen> createState() =>
      _EmbeddingAudioListScreenState();
}

class _EmbeddingAudioListScreenState extends State<EmbeddingAudioListScreen> {
  List<Map<String, dynamic>> originalList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    originalList = [
      {
        'title': 'Beautiful Life',
        'artist': 'Ace of Base',
        'watermark': 'SWT-DCT-QIM',
        'subband': 4,
        'bit': 16,
        'alfass': '0.5',
        'snr': 31.23,
        'odg': -2.56,
        'file': 'assets/audio/beautiful_life-ace_of_base.wav',
      },
      {
        'title': "Don't Speak",
        'artist': 'No Doubt',
        'watermark': 'DWT-DCT-SVD',
        'subband': 2,
        'bit': 8,
        'alfass': '0.7',
        'snr': 32.63,
        'odg': -3.43,
        'file': 'assets/audio/dont_speak-no_doubt.wav',
      },
      {
        'title': 'Evangeline',
        'artist': 'Matthew Sweet',
        'watermark': 'SWT-QR-SS',
        'subband': 3,
        'bit': 12,
        'alfass': '0.6',
        'snr': 30.21,
        'odg': -3.10,
        'file': 'assets/audio/evangeline-matthew_sweet.wav',
      },
      {
        'title': 'Host',
        'artist': 'Unknown',
        'watermark': 'DWT-SS',
        'subband': 1,
        'bit': 16,
        'alfass': '0.8',
        'snr': 29.47,
        'odg': -2.92,
        'file': 'assets/audio/host.wav',
      },
      {
        'title': 'I Ran So Far Away',
        'artist': 'Flock of Seagulls',
        'watermark': 'DWT-SVD',
        'subband': 1,
        'bit': 10,
        'alfass': 'DL-Auto',
        'snr': 28.78,
        'odg': -3.25,
        'file': 'assets/audio/i_ran_so_far_away-flock_of_seagulls.wav',
      },
    ];
    filteredList = List.from(originalList);
  }

  void _filterSearch(String query) {
    setState(() {
      filteredList =
          originalList
              .where(
                (item) =>
                    item['title'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _sortByTitle() {
    setState(() {
      isAscending = !isAscending;
      filteredList.sort(
        (a, b) =>
            isAscending
                ? a['title'].toLowerCase().compareTo(b['title'].toLowerCase())
                : b['title'].toLowerCase().compareTo(a['title'].toLowerCase()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDEB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Audio Embedding',
          style: TextStyle(
            color: Color(0xFF411530),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD1512D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${filteredList.length} audio library',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filterSearch,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
                    onPressed: _sortByTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: filteredList.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.music_note,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item['artist'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => HasilEmbeddingScreen(
                                  currentIndex: index,
                                  embeddingList: filteredList,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/history'),
    );
  }
}
