import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../exceptions/app_exception.dart' as app;
import '../utils/app_logger.dart';
import '../utils/result.dart';

/// Production facade over the Supabase client (auth, database, storage).
class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get client => SupabaseConfig.client;

  GoTrueClient get auth => client.auth;

  SupabaseStorageClient get storage => client.storage;

  User? get currentUser => auth.currentUser;

  Session? get currentSession => auth.currentSession;

  bool get isAuthenticated => currentSession != null;

  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ─── Authentication ───────────────────────────────────────────────────────

  Future<Result<AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await auth.signInWithPassword(
        email: email,
        password: password,
      );
      AppLogger.info('Signed in', response.user?.id);
      return Success(response);
    } on AuthException catch (e, st) {
      AppLogger.error('signInWithPassword failed', e, st);
      return Failure(
        app.AuthException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('signInWithPassword unexpected', e, st);
      return Failure(
        app.AuthException('Unable to sign in', cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<AuthResponse>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      AppLogger.info('Signed up', response.user?.id);
      return Success(response);
    } on AuthException catch (e, st) {
      AppLogger.error('signUp failed', e, st);
      return Failure(
        app.AuthException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('signUp unexpected', e, st);
      return Failure(
        app.AuthException('Unable to sign up', cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<void>> signOut() async {
    try {
      await auth.signOut();
      AppLogger.info('Signed out');
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('signOut failed', e, st);
      return Failure(
        app.AuthException('Unable to sign out', cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<void>> signInAnonymously() async {
    try {
      await auth.signInAnonymously();
      AppLogger.info('Anonymous session started', currentUser?.id);
      return const Success(null);
    } on AuthException catch (e, st) {
      AppLogger.error('signInAnonymously failed', e, st);
      return Failure(
        app.AuthException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('signInAnonymously unexpected', e, st);
      return Failure(
        app.AuthException('Unable to start guest session',
            cause: e, stackTrace: st),
      );
    }
  }

  // ─── Database ─────────────────────────────────────────────────────────────

  SupabaseQueryBuilder from(String table) => client.from(table);

  Future<Result<List<Map<String, dynamic>>>> select(
    String table, {
    String columns = '*',
    int? limit,
  }) async {
    try {
      final PostgrestFilterBuilder query = client.from(table).select(columns);
      final List<dynamic> rows = limit != null
          ? await query.limit(limit)
          : await query;
      final mapped = rows
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
      AppLogger.info('select $table', '${mapped.length} row(s)');
      return Success(mapped);
    } on PostgrestException catch (e, st) {
      AppLogger.error('select $table failed', e, st);
      return Failure(
        app.DatabaseException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('select $table unexpected', e, st);
      return Failure(
        app.DatabaseException('Failed to query $table',
            cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<Map<String, dynamic>>> insert(
    String table,
    Map<String, dynamic> values,
  ) async {
    try {
      final row = await client.from(table).insert(values).select().single();
      return Success(Map<String, dynamic>.from(row));
    } on PostgrestException catch (e, st) {
      AppLogger.error('insert $table failed', e, st);
      return Failure(
        app.DatabaseException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('insert $table unexpected', e, st);
      return Failure(
        app.DatabaseException('Failed to insert into $table',
            cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<Map<String, dynamic>>> update(
    String table,
    Map<String, dynamic> values, {
    required String column,
    required Object equals,
  }) async {
    try {
      final row = await client
          .from(table)
          .update(values)
          .eq(column, equals)
          .select()
          .single();
      return Success(Map<String, dynamic>.from(row));
    } on PostgrestException catch (e, st) {
      AppLogger.error('update $table failed', e, st);
      return Failure(
        app.DatabaseException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('update $table unexpected', e, st);
      return Failure(
        app.DatabaseException('Failed to update $table',
            cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<void>> delete(
    String table, {
    required String column,
    required Object equals,
  }) async {
    try {
      await client.from(table).delete().eq(column, equals);
      return const Success(null);
    } on PostgrestException catch (e, st) {
      AppLogger.error('delete $table failed', e, st);
      return Failure(
        app.DatabaseException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('delete $table unexpected', e, st);
      return Failure(
        app.DatabaseException('Failed to delete from $table',
            cause: e, stackTrace: st),
      );
    }
  }

  // ─── Storage ──────────────────────────────────────────────────────────────

  Future<Result<String>> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String? contentType,
    bool upsert = false,
  }) async {
    try {
      await storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: upsert,
            ),
          );
      final url = storage.from(bucket).getPublicUrl(path);
      return Success(url);
    } on StorageException catch (e, st) {
      AppLogger.error('uploadBytes failed', e, st);
      return Failure(
        app.StorageException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('uploadBytes unexpected', e, st);
      return Failure(
        app.StorageException('Failed to upload file',
            cause: e, stackTrace: st),
      );
    }
  }

  Future<Result<Uint8List>> downloadBytes({
    required String bucket,
    required String path,
  }) async {
    try {
      final bytes = await storage.from(bucket).download(path);
      return Success(bytes);
    } on StorageException catch (e, st) {
      AppLogger.error('downloadBytes failed', e, st);
      return Failure(
        app.StorageException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      AppLogger.error('downloadBytes unexpected', e, st);
      return Failure(
        app.StorageException('Failed to download file',
            cause: e, stackTrace: st),
      );
    }
  }

  String getPublicUrl({required String bucket, required String path}) {
    return storage.from(bucket).getPublicUrl(path);
  }

  // ─── Health ───────────────────────────────────────────────────────────────

  /// Verifies client + auth are live. Optionally probes [probeTable].
  ///
  /// A missing table (`PGRST205`) still counts as a successful connection —
  /// it proves URL + key are accepted by PostgREST.
  Future<Result<SupabaseHealth>> verifyConnection({
    String probeTable = 'animal_name',
  }) async {
    try {
      final started = DateTime.now();

      // Auth service must be constructed after initialize().
      // Touching currentSession confirms the GoTrue client is live.
      final _ = currentSession;

      var rowSampleCount = 0;
      String? probeNote;

      try {
        final rows = await client.from(probeTable).select('*').limit(1);
        rowSampleCount = (rows as List).length;
      } on PostgrestException catch (e) {
        // Connected to project; table may not be exposed / named differently.
        probeNote = e.message;
        AppLogger.info(
          'DB reachable; probe on `$probeTable` returned PostgREST error',
          '${e.code}: ${e.message}',
        );
      }

      final latency = DateTime.now().difference(started);
      final health = SupabaseHealth(
        connected: true,
        authenticated: isAuthenticated,
        userId: currentUser?.id,
        probeTable: probeTable,
        rowSampleCount: rowSampleCount,
        latency: latency,
        probeNote: probeNote,
      );
      AppLogger.info('Supabase health OK', health);
      return Success(health);
    } catch (e, st) {
      AppLogger.error('Supabase health check failed', e, st);
      return Failure(
        app.NetworkException(
          'Unable to reach Supabase',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }
}

class SupabaseHealth {
  final bool connected;
  final bool authenticated;
  final String? userId;
  final String probeTable;
  final int rowSampleCount;
  final Duration latency;
  final String? probeNote;

  const SupabaseHealth({
    required this.connected,
    required this.authenticated,
    required this.userId,
    required this.probeTable,
    required this.rowSampleCount,
    required this.latency,
    this.probeNote,
  });

  @override
  String toString() =>
      'connected=$connected auth=$authenticated table=$probeTable '
      'rows=$rowSampleCount latency=${latency.inMilliseconds}ms'
      '${probeNote != null ? ' note=$probeNote' : ''}';
}
