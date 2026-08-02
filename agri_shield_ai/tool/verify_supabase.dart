import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Standalone verification script:
///   flutter pub run --no-sound-null-safety ... 
/// Prefer: dart run via flutter test, or:
///   flutter run -d chrome  (logs probe in console)
///
/// This file is also executable with:
///   flutter test test/supabase_connection_test.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final url = dotenv.env['SUPABASE_URL']!;
  final key = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(url: url, publishableKey: key);
  final client = Supabase.instance.client;

  print('Auth ready: ${client.auth}');
  final rows = await client.from('animal_name').select('id').limit(1);
  print('DB probe OK: $rows');
}
