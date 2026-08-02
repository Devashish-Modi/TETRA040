import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/repellent_models.dart';

class RepellentController extends ChangeNotifier {
  // Equipment dashboard status
  final Map<EquipmentId, EquipmentStatus> status = {
    EquipmentId.laser: EquipmentStatus.standby,
    EquipmentId.speaker: EquipmentStatus.standby,
    EquipmentId.water: EquipmentStatus.off,
  };

  // Manual activation
  EquipmentId? activeEquipment;
  int remainingSeconds = 0;
  Timer? _timer;

  // Priority reassignment context
  WeatherType weather = WeatherType.clear;
  DayPart dayPart = DayPart.day;
  AnimalType animal = AnimalType.cow;
  List<EquipmentId> priorityOrder = [
    EquipmentId.laser,
    EquipmentId.speaker,
    EquipmentId.water,
  ];

  // Live feed
  double zoom = 1.0;
  int cameraIndex = 0;

  bool get isFiring => activeEquipment != null;

  void setEquipmentStatus(EquipmentId id, EquipmentStatus s) {
    status[id] = s;
    notifyListeners();
  }

  void switchCamera() {
    cameraIndex = (cameraIndex + 1) % 2;
    notifyListeners();
  }

  void setZoom(double v) {
    zoom = v.clamp(1.0, 3.0);
    notifyListeners();
  }

  void setWeather(WeatherType w) {
    weather = w;
    _applyDefaultPriority();
    notifyListeners();
  }

  void setDayPart(DayPart d) {
    dayPart = d;
    _applyDefaultPriority();
    notifyListeners();
  }

  void setAnimal(AnimalType a) {
    animal = a;
    _applyDefaultPriority();
    notifyListeners();
  }

  void reorderPriority(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = priorityOrder.removeAt(oldIndex);
    priorityOrder.insert(newIndex, item);
    notifyListeners();
  }

  void _applyDefaultPriority() {
    // Mirrors schema.sql style rules for demo UX.
    if (weather == WeatherType.rain) {
      if (animal == AnimalType.wildPig) {
        priorityOrder = [
          EquipmentId.water,
          EquipmentId.speaker,
          EquipmentId.laser,
        ];
      } else if (dayPart == DayPart.night) {
        priorityOrder = [
          EquipmentId.water,
          EquipmentId.speaker,
          EquipmentId.laser,
        ];
      } else {
        priorityOrder = [
          EquipmentId.speaker,
          EquipmentId.water,
          EquipmentId.laser,
        ];
      }
    } else {
      if (animal == AnimalType.wildPig && dayPart == DayPart.night) {
        priorityOrder = [
          EquipmentId.water,
          EquipmentId.laser,
          EquipmentId.speaker,
        ];
      } else if (dayPart == DayPart.night) {
        priorityOrder = [
          EquipmentId.laser,
          EquipmentId.water,
          EquipmentId.speaker,
        ];
      } else {
        priorityOrder = [
          EquipmentId.laser,
          EquipmentId.speaker,
          EquipmentId.water,
        ];
      }
    }
  }

  void startActivation(EquipmentId id, {int seconds = 15}) {
    _timer?.cancel();
    activeEquipment = id;
    remainingSeconds = seconds;
    status[id] = EquipmentStatus.on;
    for (final e in EquipmentId.values) {
      if (e != id && status[e] == EquipmentStatus.on) {
        status[e] = EquipmentStatus.standby;
      }
    }
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds <= 1) {
        stopActivation();
      } else {
        remainingSeconds -= 1;
        notifyListeners();
      }
    });
  }

  void stopActivation() {
    _timer?.cancel();
    _timer = null;
    if (activeEquipment != null) {
      status[activeEquipment!] = EquipmentStatus.standby;
    }
    activeEquipment = null;
    remainingSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
