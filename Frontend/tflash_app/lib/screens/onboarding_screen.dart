import 'package:flutter/material.dart';
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
  List<String> selectedTopics = [];
  String deliveryTime = '8:00 AM';
  String briefingLength = '10';
  bool isGenerating = false;

  final topics = [
    'Technology',
    'Politics',
    'Business',
    'Sports',
    'Entertainment',
    'Science',
    'Health',
    'World News',
    'Climate',
    'Culture',
  ];

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen()),
      );
    }
  }

  Future<void> getNewsNow() async {
    if (selectedTopics.isEmpty) return;

    final userEmail = authService.currentUser?.email;

    // Safety check: make sure the user is logged in
    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: You are not signed in.'),
          backgroundColor: Colors.red,
        ),
    );
    return;
  }

    setState(() => isGenerating = true);



    try {
      final result = await N8nService.triggerWorkflow(
        topics: selectedTopics,
        briefingLength: briefingLength,
        deliveryTime: deliveryTime,
        userEmail: userEmail, // <-- Pass the email here
      );

      print('[Success] Workflow triggered successfully.');

      // 2. Navigate to the LibraryScreen after success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your flash news is generated!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LibraryScreen()),
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isGenerating = false);
      }
    }
    }

  String get selectedTopicLabels => selectedTopics
      .take(3)
      .map((id) => topics.contains(id) ? id : '')
      .where((label) => label.isNotEmpty)
      .join(", ");

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
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.radio, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'InsidePulse',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder<bool>(
                            future: authService.isGuestMode(),
                            builder: (context, snapshot) {
                              final isGuest = snapshot.data ?? false;
                              return Text(
                                isGuest
                                    ? 'Guest Mode'
                                    : authService.currentUser?.email ?? 'User',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
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
              Spacer(),
              Divider(height: 1),
            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Library
                  ListTile(
                    leading: Icon(Icons.library_music_outlined, size: 22),
                    title: Text(
                      'Library',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LibraryScreen()),
                      );
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            
            Divider(height: 1),
            
            // Logout
            Container(
              padding: EdgeInsets.all(12),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.grey[700], size: 20),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  handleLogout();
                },
              ),
            ),
          ],
        ),
      ),
    ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'InsidePulse',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Personalized audio news, delivered on your schedule',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),
              Text(
                'What interests you?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Select topics to personalize your daily briefing',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: topics.map((topic) {
                  final isSelected = selectedTopics.contains(topic);
                  return ChoiceChip(
                    label: Text(topic),
                    selected: isSelected,
                    onSelected: (_) => toggleTopic(topic),
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              if (selectedTopics.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(
                  '${selectedTopics.length} ${selectedTopics.length == 1 ? 'topic' : 'topics'} selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
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
                      Text(
                        'Want news right now?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Get an instant briefing',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isGenerating ? null : getNewsNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isGenerating
                              ? 'Generating Your Briefing...'
                              : 'Get News Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
