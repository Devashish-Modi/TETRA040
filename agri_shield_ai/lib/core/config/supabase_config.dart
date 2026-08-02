import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

/// Initializes the Supabase Flutter client from [EnvConfig].
class SupabaseConfig {
  SupabaseConfig._();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _initialized = true;
  }

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError(
        'Supabase has not been initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return Supabase.instance.client;
  }
}
