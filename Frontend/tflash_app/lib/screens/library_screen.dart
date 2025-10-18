import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlaying;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  // Placeholder data matching your web app
  final List<Map<String, dynamic>> briefings = [
    {
      'id': '1',
      'title': 'Morning Briefing',
      'date': 'Today, 7:00 AM',
      'duration': 754,
      'topics': ['Technology', 'Business', 'World'],
      'status': 'new',
    },
    {
      'id': '2',
      'title': 'Afternoon Update',
      'date': 'Today, 2:00 PM',
      'duration': 525,
      'topics': ['Politics', 'Sports'],
      'status': 'scheduled',
    },
    {
      'id': '3',
      'title': 'Evening Digest',
      'date': 'Yesterday, 6:00 PM',
      'duration': 922,
      'topics': ['Technology', 'Science', 'Health'],
      'status': 'played',
    },
    {
      'id': '4',
      'title': 'Morning Briefing',
      'date': 'Yesterday, 7:00 AM',
      'duration': 678,
      'topics': ['Business', 'World'],
      'status': 'played',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    audioPlayer.onPositionChanged.listen((position) {
      setState(() => currentPosition = position);
    });
    
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() => totalDuration = duration);
    });
    
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playBriefing(Map<String, dynamic> briefing) {
    setState(() => currentlyPlaying = briefing['id']);
    // Placeholder - replace with actual audio URL
    // audioPlayer.play(UrlSource(briefing['audioUrl']));
  }

  void togglePlayPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String formatPosition(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Library',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Your Audio Library',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Browse your personalized news briefings',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Briefings list
                    ...briefings.map((briefing) => _buildBriefingCard(briefing)),
                  ],
                ),
              ),
            ),
          ),
          
          // Audio player bar (if playing)
          if (currentlyPlaying != null) _buildAudioPlayerBar(),
        ],
      ),
    );
  }

  Widget _buildBriefingCard(Map<String, dynamic> briefing) {
    final isCurrentlyPlaying = currentlyPlaying == briefing['id'];
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentlyPlaying ? Colors.black87 : Colors.grey[200]!,
          width: isCurrentlyPlaying ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Play button
                GestureDetector(
                  onTap: () => playBriefing(briefing),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                
                // Title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              briefing['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (briefing['status'] == 'new')
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'New',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          if (briefing['status'] == 'scheduled')
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Scheduled',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            briefing['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time,
                              size: 12, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            formatDuration(briefing['duration']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Add to queue button
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added to queue'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(Icons.playlist_add, color: Colors.grey[600]),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Topics
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (briefing['topics'] as List<String>).map((topic) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerBar() {
    final currentBriefing = briefings.firstWhere(
      (b) => b['id'] == currentlyPlaying,
      orElse: () => briefings[0],
    );
    
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
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: Colors.black87,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: Colors.black87,
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (value) {
                final position = totalDuration * value;
                audioPlayer.seek(position);
              },
            ),
          ),
          
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Play/Pause button
                IconButton(
                  onPressed: togglePlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
                
                SizedBox(width: 12),
                
                // Track info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentBriefing['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${formatPosition(currentPosition)} / ${formatPosition(totalDuration)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Skip backward
                IconButton(
                  onPressed: () {
                    final newPosition = currentPosition - Duration(seconds: 10);
                    audioPlayer.seek(newPosition);
                  },
                  icon: Icon(Icons.replay_10),
                ),
                
                // Skip forward
                IconButton(
                  onPressed: () {
                    final newPosition = currentPosition + Duration(seconds: 10);
                    audioPlayer.seek(newPosition);
                  },
                  icon: Icon(Icons.forward_10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
