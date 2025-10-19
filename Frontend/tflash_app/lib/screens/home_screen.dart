import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import 'library_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();
  final supabase = Supabase.instance.client;
  final AudioPlayer audioPlayer = AudioPlayer();

  Map<String, dynamic>? latestAudio;
  bool loading = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _fetchLatestAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _fetchLatestAudio() async {
    try {
      final response = await supabase
          .from('user_audio_files')
          .select('id, file_url, title, topic, created_at')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      setState(() {
        latestAudio = response;
        loading = false;
      });
    } catch (e) {
      print('Error fetching latest audio: $e');
      setState(() => loading = false);
    }
  }

  void _playLatest() async {
    if (latestAudio == null) return;
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(latestAudio!['file_url']));
    }
  }

  Future<void> handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('T-FLASH', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: handleLogout,
            icon: const Icon(Icons.logout, size: 18, color: Colors.black87),
            label: const Text('Logout', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
      drawer: AppDrawer(onLogout: handleLogout),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black87))
          : latestAudio == null
              ? _emptyState()
              : _buildHeroAudio(),
    );
  }

  Widget _buildHeroAudio() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            latestAudio!['title'] ?? 'Untitled',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '#${latestAudio!['topic'] ?? 'general'}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: _playLatest,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LibraryScreen()),
                );
              },
              icon: const Icon(Icons.library_music_outlined),
              label: const Text('Go to Library'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.library_music_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No audio generated yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate one or visit your Library to explore more.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LibraryScreen()),
                );
              },
              icon: const Icon(Icons.library_music),
              label: const Text('Open Library'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const AppDrawer({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.radio, color: Colors.black87),
              title: const Text('T-FLASH', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              subtitle: Text(user?.email ?? 'Guest', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.black87),
              title: const Text('Home', style: TextStyle(color: Colors.black87)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.library_music_outlined, color: Colors.black87),
              title: const Text('Library', style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LibraryScreen()),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Sign Out', style: TextStyle(color: Colors.grey)),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}