import '../config/env_config.dart';
import '../config/supabase_config.dart';
import '../services/supabase_service.dart';
import '../utils/app_logger.dart';

/// Bootstraps environment + Supabase before [runApp].
class AppBootstrap {
  AppBootstrap._();

  static Future<void> init() async {
    await EnvConfig.load();
    AppLogger.info('Env loaded', EnvConfig.supabaseUrl);

    await SupabaseConfig.initialize();
    AppLogger.info('Supabase initialized');

    // Touch auth + client to confirm services are live.
    final service = SupabaseService.instance;
    AppLogger.info(
      'Auth client ready',
      'user=${service.currentUser?.id ?? 'none'}',
    );

    final health = await service.verifyConnection();
    health.when(
      success: (h) => AppLogger.info('Database probe succeeded', h),
      failure: (e) => AppLogger.error(
        'Database probe failed (UI will still launch)',
        e,
      ),
    );
  }
}
