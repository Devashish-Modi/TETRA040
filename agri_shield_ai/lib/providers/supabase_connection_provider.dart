import 'package:flutter/foundation.dart';

import '../core/services/supabase_service.dart';
import '../core/utils/app_logger.dart';
import '../models/animal_rule.dart';
import '../repositories/animal_rule_repository.dart';

/// Holds Supabase connection / probe status for the UI layer.
class SupabaseConnectionProvider extends ChangeNotifier {
  SupabaseConnectionProvider({
    SupabaseService? service,
    AnimalRuleRepository? repository,
  })  : _service = service ?? SupabaseService.instance,
        _repository = repository ?? AnimalRuleRepository();

  final SupabaseService _service;
  final AnimalRuleRepository _repository;

  bool _ready = false;
  bool _checking = false;
  String? _error;
  SupabaseHealth? _health;
  List<AnimalRule> _sampleRules = const [];

  bool get isReady => _ready;
  bool get isChecking => _checking;
  String? get error => _error;
  SupabaseHealth? get health => _health;
  List<AnimalRule> get sampleRules => _sampleRules;
  bool get authReady => true; // Auth client is available after initialize()

  SupabaseService get service => _service;

  Future<void> verify() async {
    if (_checking) return;
    _checking = true;
    _error = null;
    notifyListeners();

    try {
      // Auth client is available as soon as Supabase.initialize succeeds.
      AppLogger.info(
        'Auth service ready',
        'session=${_service.currentSession != null}',
      );

      final healthResult = await _service.verifyConnection();
      healthResult.when(
        success: (h) {
          _health = h;
          _ready = true;
        },
        failure: (e) {
          _error = e.message;
          _ready = false;
          AppLogger.error('Connection verify failed', e);
        },
      );

      if (_ready) {
        final rules = await _repository.fetchAll(limit: 3);
        rules.when(
          success: (data) => _sampleRules = data,
          failure: (e) {
            // Keep connection success even if sample read is restricted.
            AppLogger.error('Sample animal_name read failed', e);
            _error ??= e.message;
          },
        );
      }
    } catch (e, st) {
      _ready = false;
      _error = e.toString();
      AppLogger.error('SupabaseConnectionProvider.verify crashed', e, st);
    } finally {
      _checking = false;
      notifyListeners();
    }
  }
}

final supabaseConnectionProvider = SupabaseConnectionProvider();

