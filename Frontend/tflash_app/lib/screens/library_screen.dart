import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> briefings = [];
  String? currentlyPlaying;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAudios();

    audioPlayer.onPositionChanged.listen((pos) {
      setState(() => currentPosition = pos);
    });

    audioPlayer.onDurationChanged.listen((dur) {
      setState(() => totalDuration = dur);
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _fetchAudios() async {
    try {
      final response = await supabase
          .from('user_audio_files')
          .select('id, file_url, title, topic, created_at, duration_sec')
          .order('created_at', ascending: false);

      final data = List<Map<String, dynamic>>.from(response);
      setState(() {
        briefings = data;
        loading = false;
      });
    } catch (e) {
      print('Error fetching audios: $e');
      setState(() => loading = false);
    }
  }

  void playBriefing(Map<String, dynamic> briefing) async {
    setState(() => currentlyPlaying = briefing['id']);
    await audioPlayer.play(UrlSource(briefing['file_url']));
  }

  void togglePlayPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
  }

  String formatDuration(dynamic seconds) {
    if (seconds == null) return "--:--";
    final minutes = (seconds ~/ 60);
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String formatPosition(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Library',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Audio Library',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Browse your personalized news briefings',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...briefings.map(_buildBriefingCard),
                      ],
                    ),
                  ),
                ),
                if (currentlyPlaying != null) _buildAudioPlayerBar(),
              ],
            ),
    );
  }

  Widget _buildBriefingCard(Map<String, dynamic> briefing) {
    final isCurrentlyPlaying = currentlyPlaying == briefing['id'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentlyPlaying ? Colors.black87 : Colors.grey[200]!,
          width: isCurrentlyPlaying ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: GestureDetector(
          onTap: () => playBriefing(briefing),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
        ),
        title: Text(
          briefing['title'] ?? 'Untitled Audio',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  formatDuration(briefing['duration_sec']),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateTime.tryParse(briefing['created_at'] ?? '') != null
                      ? DateTime.parse(briefing['created_at'])
                          .toLocal()
                          .toString()
                          .substring(0, 16)
                      : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (briefing['topic'] != null)
              Text(
                '#${briefing['topic']}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerBar() {
    final currentBriefing =
        briefings.firstWhere((b) => b['id'] == currentlyPlaying);
    final progress = totalDuration.inSeconds > 0
        ? currentPosition.inSeconds / totalDuration.inSeconds
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (v) =>
                audioPlayer.seek(totalDuration * v.clamp(0.0, 1.0)),
            activeColor: Colors.black87,
            inactiveColor: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: togglePlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentBriefing['title'] ?? 'Now Playing',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${formatPosition(currentPosition)} / ${formatPosition(totalDuration)}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => audioPlayer
                      .seek(currentPosition - const Duration(seconds: 10)),
                  icon: const Icon(Icons.replay_10),
                ),
                IconButton(
                  onPressed: () => audioPlayer
                      .seek(currentPosition + const Duration(seconds: 10)),
                  icon: const Icon(Icons.forward_10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
