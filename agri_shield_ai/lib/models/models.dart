import 'package:flutter/material.dart';

enum ThreatLevel { low, medium, high, critical }
enum DeviceHealth { healthy, warning, offline }

class FarmOverview {
  final String farmName;
  final String owner;
  final bool protected;
  final String statusLabel;
  final String statusDetail;
  final bool aiLive;
  final int devicesOnline;
  final int devicesTotal;
  final int animalsToday;
  final int eventsToday;
  final String weather;
  final String cameras;
  final String lastDetection;
  final int battery;

  const FarmOverview({
    required this.farmName,
    required this.owner,
    required this.protected,
    required this.statusLabel,
    required this.statusDetail,
    required this.aiLive,
    required this.devicesOnline,
    required this.devicesTotal,
    required this.animalsToday,
    required this.eventsToday,
    required this.weather,
    required this.cameras,
    required this.lastDetection,
    required this.battery,
  });
}

class LiveDetection {
  final String animal;
  final double confidence;
  final String distance;
  final String direction;
  final String detectedAt;
  final ThreatLevel threat;

  const LiveDetection({
    required this.animal,
    required this.confidence,
    required this.distance,
    required this.direction,
    required this.detectedAt,
    required this.threat,
  });
}

class SecurityEvent {
  final String id;
  final String animal;
  final String emoji;
  final String location;
  final DateTime time;
  final String action;
  final String outcome;
  final String status;
  final ThreatLevel threat;
  final double confidence;
  final String recommendation;

  const SecurityEvent({
    required this.id,
    required this.animal,
    required this.emoji,
    required this.location,
    required this.time,
    required this.action,
    required this.outcome,
    required this.status,
    required this.threat,
    required this.confidence,
    required this.recommendation,
  });
}

class FarmDevice {
  final String name;
  final String type;
  final DeviceHealth health;
  final int battery;
  final int signal;
  final String lastSeen;
  final IconData icon;

  const FarmDevice({
    required this.name,
    required this.type,
    required this.health,
    required this.battery,
    required this.signal,
    required this.lastSeen,
    required this.icon,
  });
}

class ChartPoint {
  final String label;
  final double value;
  const ChartPoint(this.label, this.value);
}
