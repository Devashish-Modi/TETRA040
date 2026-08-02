import 'package:flutter/material.dart';

enum EquipmentId { laser, speaker, water }

enum EquipmentStatus { off, standby, on }

enum WeatherType { clear, rain }

enum DayPart { day, night }

enum AnimalType { cow, buffalo, goat, wildPig }

extension EquipmentIdX on EquipmentId {
  String get label {
    switch (this) {
      case EquipmentId.laser:
        return 'Laser';
      case EquipmentId.speaker:
        return 'Speaker';
      case EquipmentId.water:
        return 'Water';
    }
  }

  String get asset {
    switch (this) {
      case EquipmentId.laser:
        return 'assets/icons/laser.svg';
      case EquipmentId.speaker:
        return 'assets/icons/speaker.svg';
      case EquipmentId.water:
        return 'assets/icons/sprinkler.svg';
    }
  }
}

extension AnimalTypeX on AnimalType {
  String get label {
    switch (this) {
      case AnimalType.cow:
        return 'Cow';
      case AnimalType.buffalo:
        return 'Buffalo';
      case AnimalType.goat:
        return 'Goat';
      case AnimalType.wildPig:
        return 'Wild Pig';
    }
  }

  String get asset {
    switch (this) {
      case AnimalType.cow:
        return 'assets/icons/cow.svg';
      case AnimalType.buffalo:
        return 'assets/icons/buffalo.svg';
      case AnimalType.goat:
        return 'assets/icons/goat.svg';
      case AnimalType.wildPig:
        return 'assets/icons/wild_pig.svg';
    }
  }
}

class SystemAlert {
  final String title;
  final String time;
  final IconData icon;
  final bool critical;
  const SystemAlert(this.title, this.time, this.icon, {this.critical = false});
}

class HistoryEvent {
  final String animal;
  final String location;
  final String time;
  final String action;
  final int confidence;
  const HistoryEvent(
      this.animal, this.location, this.time, this.action, this.confidence);
}

class DemoData {
  static const animalsToday = 7;
  static const weather = 'Clear';
  static const temperature = '31°C';
  static const liveAnimal = 'Wild Pig';
  static const liveConfidence = 92;

  static const otherAlerts = <SystemAlert>[
    SystemAlert('Low water pressure', '12 min ago', Icons.water_drop_outlined),
    SystemAlert('Speaker A offline', '41 min ago', Icons.speaker_outlined,
        critical: true),
    SystemAlert('Solar battery 87%', '1 hr ago', Icons.battery_charging_full),
    SystemAlert('Cam-02 signal weak', '2 hr ago', Icons.videocam_off_outlined),
  ];

  static const history = <HistoryEvent>[
    HistoryEvent('Wild Pig', 'North Fence', '08:14', 'Water → Speaker', 96),
    HistoryEvent('Cow', 'East Gate', '07:42', 'Laser → Speaker', 91),
    HistoryEvent('Goat', 'West Path', '06:18', 'Speaker', 84),
    HistoryEvent('Buffalo', 'South Field', 'Yesterday', 'Laser → Water', 89),
    HistoryEvent('Wild Pig', 'North Fence', 'Yesterday', 'Water', 93),
  ];

  static const weekly = [3.0, 5.0, 4.0, 8.0, 6.0, 9.0, 7.0];
}
