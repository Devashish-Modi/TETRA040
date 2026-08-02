/// Maps to the existing `animal_name` table (read-only integration).
class AnimalRule {
  final int id;
  final String weather;
  final String? time;
  final String lvl1;
  final String lvl2;
  final String lvl3;

  const AnimalRule({
    required this.id,
    required this.weather,
    required this.time,
    required this.lvl1,
    required this.lvl2,
    required this.lvl3,
  });

  factory AnimalRule.fromJson(Map<String, dynamic> json) {
    return AnimalRule(
      id: _asInt(json['id']),
      weather: (json['weather'] ?? '').toString(),
      time: json['time']?.toString(),
      lvl1: (json['lvl1'] ?? '').toString(),
      lvl2: (json['lvl2'] ?? '').toString(),
      lvl3: (json['lvl3'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'weather': weather,
        'time': time,
        'lvl1': lvl1,
        'lvl2': lvl2,
        'lvl3': lvl3,
      };

  static int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
