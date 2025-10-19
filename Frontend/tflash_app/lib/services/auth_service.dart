import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  
  Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guest_mode') ?? false;
  }
  
  Future<void> enableGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', true);
    await prefs.setInt('guest_started', DateTime.now().millisecondsSinceEpoch);
  }
  
  Future<bool> isGuestExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('guest_started');
    if (startTime == null) return true;
    
    final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
    final days = elapsed / (1000 * 60 * 60 * 24);
    return days > 7;
  }
  
  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('guest_mode');
      await prefs.remove('guest_started');
      
      return response;
    } catch (e) {
      print('[Email Sign In Error] $e');
      rethrow;
    }
  }
  
  Future<AuthResponse?> signUpWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('guest_mode');
      await prefs.remove('guest_started');
      
      return response;
    } catch (e) {
      print('[Email Sign Up Error] $e');
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    await supabase.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  User? get currentUser => supabase.auth.currentUser;
  bool get isSignedIn => currentUser != null;
}
