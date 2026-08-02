import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/db_tables.dart';
import '../core/exceptions/app_exception.dart';
import '../core/services/supabase_service.dart';
import '../core/utils/result.dart';
import '../models/animal_rule.dart';

/// Data access for the existing `animal_name` table.
class AnimalRuleRepository {
  AnimalRuleRepository({SupabaseService? service})
      : _service = service ?? SupabaseService.instance;

  final SupabaseService _service;

  Future<Result<List<AnimalRule>>> fetchAll({int? limit}) async {
    final result = await _service.select(
      DbTables.animalName,
      limit: limit,
    );

    return result.when(
      success: (rows) => Success(
        rows.map(AnimalRule.fromJson).toList(),
      ),
      failure: Failure.new,
    );
  }

  Future<Result<AnimalRule?>> findByWeather(String weather) async {
    try {
      final rows = await _service.client
          .from(DbTables.animalName)
          .select()
          .eq('weather', weather)
          .limit(1);

      final list = (rows as List)
          .map((e) => AnimalRule.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      return Success(list.isEmpty ? null : list.first);
    } on PostgrestException catch (e, st) {
      return Failure(
        DatabaseException(e.message, cause: e, stackTrace: st),
      );
    } catch (e, st) {
      return Failure(
        DatabaseException(
          'Failed to fetch animal rule for $weather',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }
}
