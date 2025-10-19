import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/n8n_service.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import 'library_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final authService = AuthService();
  final _emailController = TextEditingController();

  List<String> selectedTopics = [];
  String? _selectedNewsletterTopic;
  String deliveryTime = '8:00 AM';
  String briefingLength = '10';
  bool isGenerating = false;
  bool _isSubscribing = false;
  String _subscriptionMessage = '';
  String? _hoveredTopic;

  final topics = [
    'Technology', 'Politics', 'Business', 'Sports', 'Entertainment',
    'Science', 'Health', 'World News', 'Climate', 'Culture',
  ];

  // Map of topics to background image URLs
  final Map<String, String> topicImages = {
    'Technology': 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=600&fit=crop',
    'Politics': 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=400&h=600&fit=crop',
    'Business': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400&h=600&fit=crop',
    'Sports': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400&h=600&fit=crop',
    'Entertainment': 'https://images.unsplash.com/photo-1514306191717-452ec28c7814?w=400&h=600&fit=crop',
    'Science': 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400&h=600&fit=crop',
    'Health': 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400&h=600&fit=crop',
    'World News': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400&h=600&fit=crop',
    'Climate': 'https://images.unsplash.com/photo-1569163139599-0f4517e36f51?w=400&h=600&fit=crop',
    'Culture': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=400&h=600&fit=crop',
  };

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void toggleTopic(String topic) {
    setState(() {
      if (selectedTopics.contains(topic)) {
        selectedTopics.remove(topic);
      } else {
        selectedTopics.add(topic);
      }
    });
  }

  Future<void> handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authService.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthScreen()));
    }
  }

  Future<void> getNewsNow() async {
    if (selectedTopics.isEmpty) return;

    // Use a placeholder email for guests or logged-out users
    final userEmail = authService.currentUser?.email ?? 'guest@example.com';

    setState(() => isGenerating = true);

    try {
      await N8nService.triggerWorkflow(
        topics: selectedTopics,
        briefingLength: briefingLength,
        deliveryTime: deliveryTime,
        userEmail: userEmail,
      );

      print('[Success] Workflow triggered successfully.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your flash news is generated!'), backgroundColor: Colors.green));
        Navigator.push(context, MaterialPageRoute(builder: (_) => LibraryScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => isGenerating = false);
      }
    }
  }

  Future<void> _subscribeToNewsletter() async {
    final supabase = Supabase.instance.client;
    // Use the user's ID if available, otherwise use a null or guest identifier for your n8n workflow to handle
    final userId = supabase.auth.currentUser?.id;

    if (_emailController.text.isEmpty) {
      setState(() => _subscriptionMessage = 'Please enter a valid email.');
      return;
    }
    if (_selectedNewsletterTopic == null) {
      setState(() => _subscriptionMessage = 'Please select a topic for the newsletter.');
      return;
    }
    
    setState(() {
      _isSubscribing = true;
      _subscriptionMessage = '';
    });

    try {
      final n8nWebhookUrl = dotenv.env['N8N_NEWSLETTER'];
      if (n8nWebhookUrl == null) {
        throw Exception('N8N_WEBHOOK_URL not found in .env file');
      }

      final response = await http.post(
        Uri.parse(n8nWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId, // This can be null for guests
          'email': _emailController.text,
          'topic': _selectedNewsletterTopic,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _subscriptionMessage = "You've been subscribed!";
          _emailController.clear();
          _selectedNewsletterTopic = null;
        });
      } else {
        setState(() => _subscriptionMessage = 'An error occurred. Please try again.');
      }
    } catch (e) {
      setState(() => _subscriptionMessage = 'Failed to subscribe. Please try again.');
    } finally {
      setState(() => _isSubscribing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: handleLogout,
            icon: Icon(Icons.logout, size: 18, color: Colors.grey[700]),
            label: Text('Logout', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          ),
        ],
      ),
      drawer: AppDrawer(onLogout: handleLogout),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 14,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Text(
                    'T-FLASH',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 5,
                      shadows: [
                        Shadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Breaking news, not your focus',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              Text('What interests you?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Select topics to personalize your daily briefing',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              _buildTopicCards(),
              if (selectedTopics.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(
                  '${selectedTopics.length} ${selectedTopics.length == 1 ? 'topic' : 'topics'} selected',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
              SizedBox(height: 32),
              if (selectedTopics.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.bolt, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text('Want news right now?',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Get an instant briefing',
                          style: TextStyle(fontSize: 14, color: Colors.white70)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isGenerating ? null : getNewsNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          isGenerating ? 'Generating Your Briefing...' : 'Get News Now',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 32),
              _buildNewsletterCard(),
            ],
          ),
        ),
      ),
    );
  }

  // New widget for topic cards - horizontal scroll with hover effect and background images
  Widget _buildTopicCards() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final isSelected = selectedTopics.contains(topic);
          final isHovered = _hoveredTopic == topic;
          
          return Padding(
            padding: EdgeInsets.only(right: 12, top: 10, bottom: 10),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hoveredTopic = topic),
              onExit: (_) => setState(() => _hoveredTopic = null),
              child: AnimatedScale(
                scale: isHovered ? 1.08 : 1.0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: GestureDetector(
                  onTap: () => toggleTopic(topic),
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        if (isSelected || isHovered)
                          BoxShadow(
                            color: isSelected 
                                ? Colors.blue.withOpacity(0.4)
                                : Colors.black.withOpacity(0.2),
                            blurRadius: isHovered ? 12 : 8,
                            offset: Offset(0, isHovered ? 6 : 4),
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image
                          Image.network(
                            topicImages[topic] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                              );
                            },
                          ),
                          // Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          // Selected Overlay
                          if (isSelected)
                            Container(
                              color: Colors.blue.withOpacity(0.5),
                            ),
                          // Content
                          Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    topic,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black.withOpacity(0.8),
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsletterCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Subscribe to our Newsletter',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Get daily updates delivered to your inbox.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedNewsletterTopic,
              decoration: InputDecoration(
                labelText: 'Choose a Topic',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.topic_outlined),
              ),
              items: topics.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedNewsletterTopic = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _isSubscribing
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _subscribeToNewsletter,
                    child: const Text('Subscribe'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
            if (_subscriptionMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _subscriptionMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _subscriptionMessage.startsWith("You've") ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const AppDrawer({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.radio, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('T-FLASH', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        FutureBuilder<bool>(
                          future: authService.isGuestMode(),
                          builder: (context, snapshot) {
                            final isGuest = snapshot.data ?? false;
                            return Text(
                              isGuest ? 'Guest Mode' : authService.currentUser?.email ?? 'User',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: Icon(Icons.library_music_outlined, size: 22),
                    title: Text('Library', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LibraryScreen()));
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Container(
              padding: EdgeInsets.all(12),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.grey[700], size: 20),
                title: Text('Sign Out', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                onTap: onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}