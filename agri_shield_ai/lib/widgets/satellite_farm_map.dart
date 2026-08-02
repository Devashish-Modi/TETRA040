import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/command_theme.dart';

class MapMarker {
  final Offset normalized; // 0..1 within farm bounds
  final String id;
  final String label;
  final MapMarkerKind kind;
  final String? detail;
  final double confidence;

  const MapMarker({
    required this.normalized,
    required this.id,
    required this.label,
    required this.kind,
    this.detail,
    this.confidence = 0,
  });
}

enum MapMarkerKind { camera, sensor, threat, hub }

class SatelliteFarmMap extends StatefulWidget {
  final List<MapMarker> markers;
  final ValueChanged<MapMarker>? onMarkerTap;
  final MapMarker? selected;

  const SatelliteFarmMap({
    super.key,
    required this.markers,
    this.onMarkerTap,
    this.selected,
  });

  @override
  State<SatelliteFarmMap> createState() => _SatelliteFarmMapState();
}

class _SatelliteFarmMapState extends State<SatelliteFarmMap>
    with TickerProviderStateMixin {
  late final AnimationController _radar;
  late final AnimationController _pulse;
  final _transform = TransformationController();

  @override
  void initState() {
    super.initState();
    _radar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.sizeOf(context);
      final matrix = Matrix4.identity()
        ..translateByDouble(size.width * 0.05, size.height * 0.08, 0, 1)
        ..scaleByDouble(1.15, 1.15, 1.15, 1);
      _transform.value = matrix;
    });
  }

  @override
  void dispose() {
    _radar.dispose();
    _pulse.dispose();
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_radar, _pulse, _transform]),
      builder: (context, _) {
        return InteractiveViewer(
          transformationController: _transform,
          minScale: 0.85,
          maxScale: 3.2,
          boundaryMargin: const EdgeInsets.all(120),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (d) => _hitTest(d.localPosition, size),
                child: CustomPaint(
                  size: size,
                  painter: _SatellitePainter(
                    markers: widget.markers,
                    selectedId: widget.selected?.id,
                    radarAngle: _radar.value * math.pi * 2,
                    pulse: _pulse.value,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _hitTest(Offset local, Size size) {
    if (widget.onMarkerTap == null) return;
    final farm = _farmRect(size);
    MapMarker? best;
    var bestDist = 28.0;
    for (final m in widget.markers) {
      final p = Offset(
        farm.left + m.normalized.dx * farm.width,
        farm.top + m.normalized.dy * farm.height,
      );
      final d = (p - local).distance;
      if (d < bestDist) {
        bestDist = d;
        best = m;
      }
    }
    if (best != null) widget.onMarkerTap!(best);
  }
}

Rect _farmRect(Size size) {
  final side = math.min(size.width, size.height) * 0.92;
  return Rect.fromCenter(
    center: Offset(size.width / 2, size.height / 2),
    width: side * 1.15,
    height: side,
  );
}

class _SatellitePainter extends CustomPainter {
  final List<MapMarker> markers;
  final String? selectedId;
  final double radarAngle;
  final double pulse;

  _SatellitePainter({
    required this.markers,
    required this.selectedId,
    required this.radarAngle,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final farm = _farmRect(size);
    _paintTerrain(canvas, size, farm);
    _paintGrid(canvas, farm);
    _paintBoundary(canvas, farm);
    _paintRadar(canvas, farm);
    for (final m in markers) {
      final p = Offset(
        farm.left + m.normalized.dx * farm.width,
        farm.top + m.normalized.dy * farm.height,
      );
      _paintMarker(canvas, p, m, m.id == selectedId);
    }
    _paintCompass(canvas, size);
  }

  void _paintTerrain(Canvas canvas, Size size, Rect farm) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = CommandColors.void_,
    );

    // Distant terrain wash
    final bg = Paint()
      ..shader = RadialGradient(
        colors: const [
          Color(0xFF132018),
          CommandColors.void_,
        ],
        radius: 1.1,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final parcels = <(Rect, Color)>[
      (Rect.fromLTWH(farm.left, farm.top, farm.width * 0.48, farm.height * 0.42),
          CommandColors.mapCrop),
      (Rect.fromLTWH(farm.left + farm.width * 0.5, farm.top, farm.width * 0.5,
              farm.height * 0.38),
          CommandColors.mapField),
      (Rect.fromLTWH(farm.left, farm.top + farm.height * 0.45, farm.width * 0.55,
              farm.height * 0.55),
          CommandColors.mapField),
      (Rect.fromLTWH(farm.left + farm.width * 0.58, farm.top + farm.height * 0.4,
              farm.width * 0.42, farm.height * 0.35),
          CommandColors.mapSoil),
      (Rect.fromLTWH(farm.left + farm.width * 0.62, farm.top + farm.height * 0.72,
              farm.width * 0.38, farm.height * 0.28),
          CommandColors.mapCrop),
    ];

    for (final (r, c) in parcels) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(r.intersect(farm).deflate(2), const Radius.circular(6)),
        Paint()..color = c,
      );
      // Crop row hatching
      final hatch = Paint()
        ..color = const Color(0x22000000)
        ..strokeWidth = 1;
      for (var x = r.left; x < r.right; x += 7) {
        canvas.drawLine(Offset(x, r.top), Offset(x, r.bottom), hatch);
      }
    }

    // Irrigation canal
    final canal = Path()
      ..moveTo(farm.left + farm.width * 0.08, farm.top + farm.height * 0.55)
      ..quadraticBezierTo(
        farm.left + farm.width * 0.4,
        farm.top + farm.height * 0.58,
        farm.left + farm.width * 0.92,
        farm.top + farm.height * 0.48,
      );
    canvas.drawPath(
      canal,
      Paint()
        ..color = CommandColors.mapWater
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      canal,
      Paint()
        ..color = const Color(0x442EC4FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Access road
    final road = Path()
      ..moveTo(farm.left + farm.width * 0.02, farm.bottom)
      ..lineTo(farm.left + farm.width * 0.35, farm.top + farm.height * 0.62)
      ..lineTo(farm.left + farm.width * 0.72, farm.top + farm.height * 0.22);
    canvas.drawPath(
      road,
      Paint()
        ..color = CommandColors.mapRoad
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Soft vignette inside farm
    canvas.drawRRect(
      RRect.fromRectAndRadius(farm, const Radius.circular(18)),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.35),
          ],
        ).createShader(farm),
    );
  }

  void _paintGrid(Canvas canvas, Rect farm) {
    final paint = Paint()
      ..color = const Color(0x14A8C5D8)
      ..strokeWidth = 0.8;
    const steps = 8;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      canvas.drawLine(
        Offset(farm.left + farm.width * t, farm.top),
        Offset(farm.left + farm.width * t, farm.bottom),
        paint,
      );
      canvas.drawLine(
        Offset(farm.left, farm.top + farm.height * t),
        Offset(farm.right, farm.top + farm.height * t),
        paint,
      );
    }
  }

  void _paintBoundary(Canvas canvas, Rect farm) {
    final r = RRect.fromRectAndRadius(farm, const Radius.circular(18));
    canvas.drawRRect(
      r,
      Paint()
        ..color = CommandColors.hud.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    // Corner brackets
    final b = Paint()
      ..color = CommandColors.hud
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    const len = 18.0;
    final corners = [
      (farm.topLeft, 1.0, 1.0),
      (farm.topRight, -1.0, 1.0),
      (farm.bottomLeft, 1.0, -1.0),
      (farm.bottomRight, -1.0, -1.0),
    ];
    for (final (o, sx, sy) in corners) {
      canvas.drawLine(o, o + Offset(len * sx, 0), b);
      canvas.drawLine(o, o + Offset(0, len * sy), b);
    }
  }

  void _paintRadar(Canvas canvas, Rect farm) {
    final center = farm.center;
    final radius = farm.shortestSide * 0.42;
    for (final f in [0.33, 0.66, 1.0]) {
      canvas.drawCircle(
        center,
        radius * f,
        Paint()
          ..color = CommandColors.hud.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    final sweep = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        radarAngle - 0.55,
        0.55,
        false,
      )
      ..close();
    canvas.drawPath(
      sweep,
      Paint()
        ..shader = SweepGradient(
          startAngle: radarAngle - 0.55,
          endAngle: radarAngle,
          colors: [
            Colors.transparent,
            CommandColors.hud.withValues(alpha: 0.28),
          ],
          transform: GradientRotation(radarAngle - 0.55),
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    canvas.drawLine(
      center,
      center + Offset(math.cos(radarAngle), math.sin(radarAngle)) * radius,
      Paint()
        ..color = CommandColors.hud.withValues(alpha: 0.85)
        ..strokeWidth = 2,
    );
  }

  void _paintMarker(Canvas canvas, Offset p, MapMarker m, bool selected) {
    switch (m.kind) {
      case MapMarkerKind.threat:
        final r = 10.0 + pulse * 6;
        canvas.drawCircle(
          p,
          r,
          Paint()..color = CommandColors.threat.withValues(alpha: 0.22),
        );
        canvas.drawCircle(
          p,
          7,
          Paint()
            ..color = CommandColors.threat
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        canvas.drawCircle(p, 3.5, Paint()..color = CommandColors.threat);
        _label(canvas, p + const Offset(0, 16), m.label, CommandColors.threat);
      case MapMarkerKind.camera:
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: p, width: 18, height: 14),
          const Radius.circular(3),
        );
        canvas.drawRRect(rect, Paint()..color = CommandColors.cyan);
        canvas.drawCircle(
          p + const Offset(10, 0),
          4,
          Paint()..color = CommandColors.cyan,
        );
        if (selected) {
          canvas.drawCircle(
            p,
            16,
            Paint()
              ..color = CommandColors.cyan.withValues(alpha: 0.35)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }
        _label(canvas, p + const Offset(0, 16), m.label, CommandColors.cyan);
      case MapMarkerKind.sensor:
        canvas.drawCircle(
          p,
          6,
          Paint()
            ..color = CommandColors.amber
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        canvas.drawCircle(p, 2.5, Paint()..color = CommandColors.amber);
        _label(canvas, p + const Offset(0, 14), m.label, CommandColors.amber);
      case MapMarkerKind.hub:
        final path = Path()
          ..moveTo(p.dx, p.dy - 9)
          ..lineTo(p.dx + 8, p.dy + 6)
          ..lineTo(p.dx - 8, p.dy + 6)
          ..close();
        canvas.drawPath(path, Paint()..color = CommandColors.hud);
        _label(canvas, p + const Offset(0, 16), m.label, CommandColors.hud);
    }
  }

  void _label(Canvas canvas, Offset p, String text, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy));
  }

  void _paintCompass(Canvas canvas, Size size) {
    final o = Offset(size.width - 36, size.height - 36);
    canvas.drawCircle(
      o,
      18,
      Paint()..color = const Color(0x88000000),
    );
    canvas.drawCircle(
      o,
      18,
      Paint()
        ..color = CommandColors.panelEdge
        ..style = PaintingStyle.stroke,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          color: CommandColors.hud,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(o.dx - tp.width / 2, o.dy - 14));
  }

  @override
  bool shouldRepaint(covariant _SatellitePainter old) =>
      old.radarAngle != radarAngle ||
      old.pulse != pulse ||
      old.selectedId != selectedId ||
      old.markers != markers;
}
