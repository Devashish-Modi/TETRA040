import 'package:flutter/material.dart';

enum EquipmentId { laser, speaker, water }

enum EquipmentStatus { off, standby, on }

enum WeatherType { clear, rain }

enum DayPart { day, night }

enum AnimalType { cow, buffalo, goat, wildPig }

enum EventOutcome { repelled, breached }

extension EquipmentIdX on EquipmentId {
  String get label {
    switch (this) {
      case EquipmentId.laser:
        return 'Laser';
      case EquipmentId.speaker:
        return 'Speaker';
      case EquipmentId.water:
        return 'Water Sprinkler';
    }
  }

  String get shortLabel {
    switch (this) {
      case EquipmentId.laser:
        return 'Laser';
      case EquipmentId.speaker:
        return 'Speaker';
      case EquipmentId.water:
        return 'Water';
    }
  }

  String get description {
    switch (this) {
      case EquipmentId.laser:
        return 'Scares animals with light';
      case EquipmentId.speaker:
        return 'Plays loud sounds to move them away';
      case EquipmentId.water:
        return 'Sprays a strong water jet';
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

  IconData get materialIcon {
    switch (this) {
      case EquipmentId.laser:
        return Icons.highlight_rounded;
      case EquipmentId.speaker:
        return Icons.volume_up_rounded;
      case EquipmentId.water:
        return Icons.water_drop_rounded;
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

/// Maps to PostgreSQL animal_name rule row (weather, time, lvl1–3).
class PriorityRule {
  final String weather; // e.g. Clear-Cow
  final String time; // Day / Night
  final String lvl1;
  final String lvl2;
  final String lvl3;

  const PriorityRule({
    required this.weather,
    required this.time,
    required this.lvl1,
    required this.lvl2,
    required this.lvl3,
  });
}

class FarmAlert {
  final String message;
  final String time;
  final IconData icon;
  final bool urgent;
  const FarmAlert(this.message, this.time, this.icon, {this.urgent = false});
}

class HistoryEvent {
  final AnimalType animal;
  final String when;
  final WeatherType weather;
  final String equipmentUsed;
  final EventOutcome outcome;

  const HistoryEvent({
    required this.animal,
    required this.when,
    required this.weather,
    required this.equipmentUsed,
    required this.outcome,
  });
}

class FarmData {
  static const farmerName = 'Ramesh';
  static const animalsToday = 7;
  static const weatherLabel = 'Clear';
  static const temperature = '31°C';
  static const liveAnimal = AnimalType.wildPig;
  static const liveConfidenceLabel = 'very_sure';

  static const alerts = <FarmAlert>[
    FarmAlert('alert_water_low', '12 min ago', Icons.water_drop_rounded),
    FarmAlert('alert_camera_offline', '41 min ago', Icons.videocam_off_rounded,
        urgent: true),
    FarmAlert('alert_battery_ok', '1 hr ago', Icons.battery_charging_full_rounded),
    FarmAlert('alert_speaker_check', '2 hr ago', Icons.volume_up_rounded),
  ];

  static const history = <HistoryEvent>[
    HistoryEvent(
      animal: AnimalType.wildPig,
      when: 'Today · 8:14 AM',
      weather: WeatherType.rain,
      equipmentUsed: 'Water → Speaker',
      outcome: EventOutcome.repelled,
    ),
    HistoryEvent(
      animal: AnimalType.cow,
      when: 'Today · 7:42 AM',
      weather: WeatherType.clear,
      equipmentUsed: 'Laser → Speaker',
      outcome: EventOutcome.repelled,
    ),
    HistoryEvent(
      animal: AnimalType.goat,
      when: 'Yesterday · 6:18 PM',
      weather: WeatherType.clear,
      equipmentUsed: 'Speaker',
      outcome: EventOutcome.repelled,
    ),
    HistoryEvent(
      animal: AnimalType.buffalo,
      when: 'Yesterday · 9:05 PM',
      weather: WeatherType.rain,
      equipmentUsed: 'Laser',
      outcome: EventOutcome.breached,
    ),
    HistoryEvent(
      animal: AnimalType.wildPig,
      when: '2 days ago · 11:20 PM',
      weather: WeatherType.rain,
      equipmentUsed: 'Water',
      outcome: EventOutcome.repelled,
    ),
  ];

  static const monthlyAnimals = {
    'cow': 12.0,
    'buffalo': 8.0,
    'goat': 6.0,
    'wild_pig': 15.0,
  };

  static const suggestions = [
    'Wild pigs mostly come at night in rain — try water spray first.',
    'On clear days, laser light often works well as the first step.',
    'If animals return often to the same fence, check that camera first.',
  ];
}
