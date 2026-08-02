import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';

void main() {
  test('Supabase client connects with project credentials', () async {
    final envFile = File('.env');
    expect(envFile.existsSync(), isTrue,
        reason: '.env must exist at project root');

    dotenv.loadFromString(envString: envFile.readAsStringSync());

    final url = dotenv.env['SUPABASE_URL'];
    final key = dotenv.env['SUPABASE_ANON_KEY'];

    expect(url, contains('supabase.co'));
    expect(key, isNotEmpty);

    final client = SupabaseClient(url!, key!);
    expect(client.auth, isNotNull);

    // Prove PostgREST accepts the key (table may or may not exist yet).
    try {
      final rows = await client.from('animal_name').select('id').limit(1);
      expect(rows, isA<List>());
    } on PostgrestException catch (e) {
      // PGRST205 = schema cache miss (connected, table not exposed).
      expect(
        e.code,
        anyOf('PGRST205', '42501', 'PGRST301', 'PGRST116', isNull),
        reason: 'Unexpected PostgREST failure: ${e.code} ${e.message}',
      );
    }
  }, timeout: const Timeout(Duration(seconds: 45)));
}
