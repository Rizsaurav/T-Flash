import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InsidePulse', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Logout button - low contrast
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(onLogout: handleLogout),
      body: Center(
        child: Text('Your content here'),
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
    final isGuest = authService.isGuestMode();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                  isGuest ? 'Guest Mode' : user?.email ?? 'User',
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
                ],
              ),
            ),
            
            Divider(height: 1),
            
            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.library_music_outlined,
                    label: 'Library',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to library
                    },
                  ),
                  DrawerItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Schedule',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to schedule
                    },
                  ),
                  DrawerItem(
                    icon: Icons.trending_up_outlined,
                    label: 'Trending',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to trending
                    },
                  ),
                  DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings
                    },
                  ),
                ],
              ),
            ),
            
            Divider(height: 1),
            
            // Logout button at bottom - low contrast
            Container(
              padding: EdgeInsets.all(12),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.grey[700], size: 20),
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onLogout();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
