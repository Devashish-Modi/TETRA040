/// Loads and validates environment variables for AgriShield AI.
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static const String _envAsset = '.env';

  static Future<void> load() async {
    await dotenv.load(fileName: _envAsset);
  }

  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL']?.trim() ?? '';
    if (value.isEmpty) {
      throw StateError('SUPABASE_URL is missing in .env');
    }
    return value;
  }

  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';
    if (value.isEmpty) {
      throw StateError('SUPABASE_ANON_KEY is missing in .env');
    }
    return value;
  }

  static bool get isConfigured {
    final url = dotenv.env['SUPABASE_URL']?.trim() ?? '';
    final key = dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';
    return url.isNotEmpty && key.isNotEmpty;
  }
}
