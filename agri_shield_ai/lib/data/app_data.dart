class AppData {
  AppData._();

  static const farmer = 'Ramesh Patil';
  static const farm = 'Green Valley Perimeter';
  static const village = 'Khedgaon, Nashik';
  static const phone = '+91 98765 43210';

  static const protected = true;
  static const camerasOnline = 2;
  static const camerasTotal = 2;
  static const battery = 87;
  static const solarCharging = true;
  static const animalsToday = 7;
  static const activeAlerts = 2;
  static const weather = 'Clear · 31°C';
  static const lastDetection = 'Wild Pig · North Fence · 8 min ago';

  static const liveAnimal = 'Cow';
  static const liveConfidence = 98;
  static const liveDistance = '18 m';
  static const liveDirection = 'Moving east';
  static const liveTime = '14:32:08';
  static const liveAlarmLevel = 2;

  static const alarmLevels = <AlarmLevel>[
    AlarmLevel(1, 'Level 1', 'Soft warning', 'Laser', 'Visual deterrent'),
    AlarmLevel(2, 'Level 2', 'Active alert', 'Speaker', 'Audio deterrent'),
    AlarmLevel(3, 'Level 3', 'Critical', 'Water', 'Full response'),
  ];

  static final alerts = <AlertItem>[
    AlertItem(
      'Wild Pig',
      '🐗',
      'North Fence',
      '8 min ago',
      3,
      96,
      true,
      'Escalate to Level 3 · Water deterrent',
    ),
    AlertItem(
      'Cow',
      '🐄',
      'East Gate',
      '24 min ago',
      2,
      91,
      true,
      'Activate Speaker · Monitor movement',
    ),
    AlertItem(
      'Goat',
      '🐐',
      'West Path',
      '2 hr ago',
      1,
      84,
      false,
      'Soft Laser pulse · Resolved',
    ),
    AlertItem(
      'Buffalo',
      '🐃',
      'South Field',
      '4 hr ago',
      2,
      89,
      false,
      'Speaker cycle complete',
    ),
  ];

  static final devices = <DeviceItem>[
    DeviceItem('ESP32 Hub', 'Controller', true, 100, 94),
    DeviceItem('Cam-01 North', 'Camera', true, 92, 88),
    DeviceItem('Cam-02 East', 'Camera', true, 86, 81),
    DeviceItem('Speaker A', 'Speaker', true, 78, 85),
    DeviceItem('Solar Array', 'Solar', true, 100, 96),
    DeviceItem('Battery Pack', 'Battery', true, 87, 90),
    DeviceItem('PIR North', 'Sensor', true, 54, 62),
    DeviceItem('LED Strobe', 'Deterrent', false, 8, 0),
  ];

  static const weekly = [4.0, 7.0, 5.0, 9.0, 6.0, 11.0, 7.0];
  static const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
}

class AlertItem {
  final String animal;
  final String emoji;
  final String location;
  final String time;
  final int level;
  final int confidence;
  final bool active;
  final String recommendation;

  const AlertItem(
    this.animal,
    this.emoji,
    this.location,
    this.time,
    this.level,
    this.confidence,
    this.active,
    this.recommendation,
  );

  String get levelLabel => 'Level $level';
}

class AlarmLevel {
  final int level;
  final String title;
  final String subtitle;
  final String action;
  final String detail;
  const AlarmLevel(
      this.level, this.title, this.subtitle, this.action, this.detail);
}

class DeviceItem {
  final String name;
  final String type;
  final bool online;
  final int battery;
  final int signal;
  const DeviceItem(
      this.name, this.type, this.online, this.battery, this.signal);
}
