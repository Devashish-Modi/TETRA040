import 'package:flutter/foundation.dart';

import '../core/services/supabase_service.dart';
import '../core/utils/app_logger.dart';
import '../data/app_data.dart';
import '../models/animal_rule.dart';
import '../repositories/animal_rule_repository.dart';

/// Loads three-level alarm rules from Supabase `animal_name`.
class AnimalRuleProvider extends ChangeNotifier {
  AnimalRuleProvider({
    AnimalRuleRepository? repository,
    SupabaseService? service,
  })  : _repository = repository ?? AnimalRuleRepository(),
        _service = service ?? SupabaseService.instance;

  final AnimalRuleRepository _repository;
  final SupabaseService _service;

  bool loading = false;
  bool connected = false;
  String? error;
  AnimalRule? rule;
  List<AlarmLevel> alarmLevels = List<AlarmLevel>.from(AppData.alarmLevels);
  String source = 'local';

  Future<void> loadForLiveDetection({
    String condition = 'Clear',
    String? animal,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    final weatherKey = '$condition-${animal ?? AppData.liveAnimal}';

    try {
      final health = await _service.verifyConnection();
      connected = health.isSuccess;

      final result = await _repository.findByWeather(weatherKey);
      await result.when(
        success: (data) async {
          if (data != null) {
            rule = data;
            alarmLevels = _mapRule(data);
            source = 'supabase';
            error = null;
            AppLogger.info('Loaded alarm rule from Supabase', weatherKey);
          } else {
            // Try any row so UI still binds to remote DB when exact key missing.
            final all = await _repository.fetchAll(limit: 1);
            all.when(
              success: (rows) {
                if (rows.isNotEmpty) {
                  rule = rows.first;
                  alarmLevels = _mapRule(rows.first);
                  source = 'supabase';
                  error = null;
                } else {
                  source = 'local';
                  error =
                      'Supabase connected, but no rows in animal_name for $weatherKey';
                }
              },
              failure: (e) {
                source = 'local';
                error = e.message;
              },
            );
          }
        },
        failure: (e) async {
          source = 'local';
          error = e.message;
          AppLogger.error('Supabase animal_name fetch failed', e);
        },
      );
    } catch (e, st) {
      source = 'local';
      connected = false;
      error = e.toString();
      AppLogger.error('AnimalRuleProvider.load failed', e, st);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<AlarmLevel> _mapRule(AnimalRule r) {
    return [
      AlarmLevel(1, 'Level 1', 'Soft warning', r.lvl1, 'From Supabase lvl1'),
      AlarmLevel(2, 'Level 2', 'Active alert', r.lvl2, 'From Supabase lvl2'),
      AlarmLevel(3, 'Level 3', 'Critical', r.lvl3, 'From Supabase lvl3'),
    ];
  }
}

final animalRuleProvider = AnimalRuleProvider();
