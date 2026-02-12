import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('recipe_history');

    setState(() {
      if (historyJson != null) {
        final List<dynamic> decodedList = json.decode(historyJson);
        _history = decodedList
            .map<Map<String, dynamic>>(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();

        // Sort by timestamp (newest first)
        _history.sort((a, b) {
          int timeA = int.tryParse(a['timestamp'].toString()) ?? 0;
          int timeB = int.tryParse(b['timestamp'].toString()) ?? 0;
          return timeB.compareTo(timeA);
        });
      }
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recipe_history');
    setState(() {
      _history = [];
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Riwayat berhasil dihapus'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF8B4513),
        ),
      );
    }
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.78,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEED6),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Hapus semua riwayat?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A4A2E),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Riwayat yang sudah dihapus tidak\nbisa dikembalikan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF7A4A2E).withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _clearHistory();
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8A77B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6BE97),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7A4A2E),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    int parsedTimestamp;

    if (timestamp is int) {
      parsedTimestamp = timestamp;
    } else if (timestamp is String) {
      parsedTimestamp = int.tryParse(timestamp) ?? 0;
    } else {
      parsedTimestamp = 0;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(parsedTimestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF8F3),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFB8956A)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF8B5A3C),
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Riwayat',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5A3C),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  if (_history.isNotEmpty)
                    GestureDetector(
                      onTap: _showClearHistoryDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8D5B7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: const Color(0xFF8B5A3C).withOpacity(0.8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B5A3C).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: _history.isEmpty
                  ? _buildEmptyState()
                  : _buildHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D5B7).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.history,
              size: 60,
              color: const Color(0xFF8B5A3C).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada riwayat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5A3C),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Resep yang kamu lihat akan muncul di sini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF8B5A3C).withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HISTORY LIST
  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // Navigate to recipe detail
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // RECIPE IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['imagePath'] ?? 'assets/makan.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D5B7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            size: 32,
                            color: Color(0xFF8B5A3C),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),

                  // RECIPE INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? 'Resep',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5A3C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (item['location'] != null &&
                            item['location'].toString().isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: const Color(0xFF8B5A3C).withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['location'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(
                                      0xFF8B5A3C,
                                    ).withOpacity(0.5),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: const Color(0xFF8B5A3C).withOpacity(0.4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimestamp(item['timestamp'] ?? 0),
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFF8B5A3C).withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ARROW ICON
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: const Color(0xFF8B5A3C).withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================
// HELPER FUNCTION - Add to History
// ============================================
Future<void> addToHistory(Map<String, dynamic> recipe) async {
  final prefs = await SharedPreferences.getInstance();
  final String? historyJson = prefs.getString('recipe_history');

  List<dynamic> history = [];
  if (historyJson != null) {
    history = json.decode(historyJson);
  }

  // Remove if already exists (to avoid duplicates)
  history.removeWhere((item) => item['id'] == recipe['id']);

  // Add timestamp
  recipe['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();

  // Add to beginning of list
  history.insert(0, recipe);

  // Keep only last 50 items
  if (history.length > 50) {
    history = history.sublist(0, 50);
  }

  await prefs.setString('recipe_history', json.encode(history));
}
