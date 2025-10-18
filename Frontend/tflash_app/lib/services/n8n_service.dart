import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

class N8nService {
  static Future<Map<String, dynamic>> triggerWorkflow({
    required List<String> topics,
    required String briefingLength,
    required String deliveryTime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(EnvConfig.n8nWebhookUrl), // Using .env
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'event': 'generate_news_now',
          'topics': topics,
          'briefingLength': briefingLength,
          'deliveryTime': deliveryTime,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to trigger workflow: ${response.statusCode}');
      }
    } catch (e) {
      print('[N8N Error] $e');
      rethrow;
    }
  }
}
