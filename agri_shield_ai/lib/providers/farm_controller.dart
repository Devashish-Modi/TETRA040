import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/farm_models.dart';

class FarmDevice {
  final String name;
  final String type;
  bool online;
  FarmDevice(this.name, this.type, this.online);
}

class FarmController extends ChangeNotifier {
  final Map<EquipmentId, EquipmentStatus> status = {
    EquipmentId.laser: EquipmentStatus.standby,
    EquipmentId.speaker: EquipmentStatus.standby,
    EquipmentId.water: EquipmentStatus.off,
  };

  EquipmentId? activeEquipment;
  int remainingSeconds = 0;
  Timer? _timer;

  WeatherType weather = WeatherType.clear;
  DayPart dayPart = DayPart.day;
  AnimalType animal = AnimalType.cow;
  List<EquipmentId> priorityOrder = [
    EquipmentId.laser,
    EquipmentId.speaker,
    EquipmentId.water,
  ];

  double zoom = 1.0;
  int cameraIndex = 0;
  bool flashOn = false;
  bool recording = false;
  int snapshotCount = 0;
  String? lastSnapshotAt;

  PriorityRule? lastSavedRule;
  final List<FarmAlert> alerts = List<FarmAlert>.from(FarmData.alerts);

  final List<FarmDevice> devices = [
    FarmDevice('Cam-01 North', 'Camera', true),
    FarmDevice('Cam-02 East', 'Camera', false),
    FarmDevice('Speaker A', 'Speaker', true),
    FarmDevice('Laser Unit', 'Laser', true),
    FarmDevice('Water Sprinkler', 'Sprinkler', true),
    FarmDevice('Solar Battery', 'Power', true),
  ];

  AnimalType? filterAnimal;
  WeatherType? filterWeather;

  bool get isFiring => activeEquipment != null;

  String get currentlyActiveLabel {
    if (activeEquipment != null) {
      return 'Currently Active: ${activeEquipment!.shortLabel}';
    }
    return 'Currently Active: None';
  }

  void switchCamera() {
    cameraIndex = (cameraIndex + 1) % 2;
    notifyListeners();
  }

  void setZoom(double v) {
    zoom = v.clamp(1.0, 3.0);
    notifyListeners();
  }

  void toggleFlash() {
    flashOn = !flashOn;
    notifyListeners();
  }

  void toggleRecording() {
    recording = !recording;
    notifyListeners();
  }

  void takeSnapshot() {
    snapshotCount += 1;
    final now = DateTime.now();
    lastSnapshotAt =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  void cycleEquipmentStatus(EquipmentId id) {
    if (activeEquipment == id) return;
    switch (status[id]!) {
      case EquipmentStatus.off:
        status[id] = EquipmentStatus.standby;
        break;
      case EquipmentStatus.standby:
        status[id] = EquipmentStatus.on;
        break;
      case EquipmentStatus.on:
        status[id] = EquipmentStatus.off;
        break;
    }
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

  void setFilterAnimal(AnimalType? a) {
    filterAnimal = a;
    notifyListeners();
  }

  void setFilterWeather(WeatherType? w) {
    filterWeather = w;
    notifyListeners();
  }

  void reorderPriority(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = priorityOrder.removeAt(oldIndex);
    priorityOrder.insert(newIndex, item);
    notifyListeners();
  }

  PriorityRule toPriorityRule() {
    final key =
        '${weather == WeatherType.clear ? 'Clear' : 'Rain'}-${animal.label.replaceAll(' ', '')}';
    return PriorityRule(
      weather: key,
      time: dayPart == DayPart.day ? 'Day' : 'Night',
      lvl1: priorityOrder[0].shortLabel,
      lvl2: priorityOrder[1].shortLabel,
      lvl3: priorityOrder[2].shortLabel,
    );
  }

  void savePriority() {
    lastSavedRule = toPriorityRule();
    notifyListeners();
  }

  void dismissAlert(int index) {
    if (index < 0 || index >= alerts.length) return;
    alerts.removeAt(index);
    notifyListeners();
  }

  void clearAlerts() {
    alerts.clear();
    notifyListeners();
  }

  void toggleDevice(int index) {
    if (index < 0 || index >= devices.length) return;
    devices[index].online = !devices[index].online;
    notifyListeners();
  }

  void _applyDefaultPriority() {
    if (weather == WeatherType.rain) {
      if (animal == AnimalType.wildPig || dayPart == DayPart.night) {
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
    } else if (dayPart == DayPart.night) {
      if (animal == AnimalType.wildPig) {
        priorityOrder = [
          EquipmentId.water,
          EquipmentId.laser,
          EquipmentId.speaker,
        ];
      } else {
        priorityOrder = [
          EquipmentId.laser,
          EquipmentId.water,
          EquipmentId.speaker,
        ];
      }
    } else {
      priorityOrder = [
        EquipmentId.laser,
        EquipmentId.speaker,
        EquipmentId.water,
      ];
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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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

  List<HistoryEvent> get filteredHistory {
    return FarmData.history.where((e) {
      if (filterAnimal != null && e.animal != filterAnimal) return false;
      if (filterWeather != null && e.weather != filterWeather) return false;
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
