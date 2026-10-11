import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/entities/location_selection.dart';
import '../../domain/usecases/qibla.dart';
import '../../services/sensors/compass_service.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/state_views.dart';
import '../prayer/providers/location_setup_provider.dart';
import '../prayer/providers/prayer_providers.dart';
import '../prayer/widgets/city_picker_sheet.dart';

final compassServiceProvider = Provider<CompassService>(
  (ref) => const FlutterCompassService(),
);

/// Live heading. A device without a compass yields a single reading with a
/// null heading (a value, not an error, so nothing retries).
final compassProvider = StreamProvider.autoDispose<CompassReading>(
  (ref) =>
      ref.watch(compassServiceProvider).readings ??
      Stream.value(const CompassReading(heading: null)),
);

/// Within this many degrees the user is considered to face the qibla.
const double qiblaTolerance = 5;

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final location = ref.watch(resolvedLocationProvider);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.featureQibla),
        actions: [
          IconButton(
            tooltip: l10n.qiblaCalibrationTitle,
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => _showCalibration(context),
          ),
        ],
      ),
      body: location == null
          ? EmptyState(
              icon: Icons.explore_off_outlined,
              title: l10n.qiblaNeedsLocation,
              actionLabel: l10n.locationChooseCity,
              onAction: () async {
                final city = await showCityPicker(context);
                if (city != null) {
                  await ref
                      .read(locationSetupProvider.notifier)
                      .chooseCity(city);
                }
              },
            )
          : ResponsiveBody(child: _QiblaBody(location: location)),
    );
  }
}

void _showCalibration(BuildContext context) {
  showHadeelBottomSheet<void>(
    context: context,
    builder: (context) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.screen_rotation_alt_rounded,
              size: 48,
              color: context.colors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.qiblaCalibrationTitle,
              style: context.text.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.qiblaCalibrationBody,
              style: context.text.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

class _QiblaBody extends ConsumerStatefulWidget {
  const _QiblaBody({required this.location});

  final ResolvedLocation location;

  @override
  ConsumerState<_QiblaBody> createState() => _QiblaBodyState();
}

class _QiblaBodyState extends ConsumerState<_QiblaBody> {
  bool _isAligned(double? heading, double bearing) =>
      heading != null &&
      turnToQibla(heading: heading, bearing: bearing).abs() <= qiblaTolerance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final f = context.formatters;
    final bearing = qiblaBearing(widget.location.coordinates);
    final distance = distanceToKaabaKm(widget.location.coordinates);
    final compass = ref.watch(compassProvider);
    // A single gentle haptic when the phone comes into line with the qibla.
    ref.listen(compassProvider, (prev, next) {
      if (_isAligned(next.value?.heading, bearing) &&
          !_isAligned(prev?.value?.heading, bearing)) {
        HapticFeedback.mediumImpact();
      }
    });
    final heading = compass.value?.heading;
    final noSensor = compass.hasError || (compass.hasValue && heading == null);
    final accuracy = compass.value?.accuracy;

    double? turn;
    var aligned = false;
    if (heading != null) {
      turn = turnToQibla(heading: heading, bearing: bearing);
      aligned = turn.abs() <= qiblaTolerance;
    }

    final place =
        widget.location.city?.localizedName(context.languageCode) ??
        l10n.locationCurrent;
    final status = noSensor
        ? l10n.qiblaNoSensor
        : turn == null
        ? l10n.qiblaDirectionLabel
        : aligned
        ? l10n.qiblaAligned
        : turn > 0
        ? l10n.qiblaTurnRight
        : l10n.qiblaTurnLeft;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenGutter),
      children: [
        Semantics(
          liveRegion: true,
          child: AnimatedDefaultTextStyle(
            duration: AppMotion.medium,
            style: context.text.titleLarge!.copyWith(
              color: aligned
                  ? context.brand.goldText
                  : context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
            child: Text(status),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: LayoutBuilder(
            builder: (context, c) {
              final size = math.min(c.maxWidth, 320.0);
              return _Compass(
                size: size,
                // Without a sensor, show the dial fixed to north.
                heading: heading ?? 0,
                bearing: bearing,
                aligned: aligned,
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        HadeelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoRow(
                Icons.explore_outlined,
                l10n.qiblaBearing(f.number(bearing.round())),
              ),
              _InfoRow(Icons.place_outlined, place),
              _InfoRow(
                Icons.straighten_rounded,
                l10n.qiblaDistance(f.number(distance.round())),
              ),
              if (heading != null)
                _InfoRow(
                  Icons.navigation_outlined,
                  l10n.qiblaHeading(f.number(heading.round())),
                ),
              if (accuracy != null && accuracy > 30)
                _InfoRow(
                  Icons.warning_amber_rounded,
                  l10n.qiblaCalibrationBody,
                  color: context.colors.error,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text, {this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? context.colors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: context.text.bodyMedium!.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dial that rotates with the phone so north stays north; the Kaaba marker
/// sits at the qibla bearing. When the marker reaches the top, the phone
/// faces the qibla.
class _Compass extends StatefulWidget {
  const _Compass({
    required this.size,
    required this.heading,
    required this.bearing,
    required this.aligned,
  });

  final double size;
  final double heading;
  final double bearing;
  final bool aligned;

  @override
  State<_Compass> createState() => _CompassState();
}

class _CompassState extends State<_Compass> {
  // Continuous (unwrapped) angle so 359° → 1° turns 2°, not 358°.
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _angle = -widget.heading;
  }

  @override
  void didUpdateWidget(_Compass old) {
    super.didUpdateWidget(old);
    final target = -widget.heading;
    var delta = (target - _angle) % 360;
    if (delta > 180) delta -= 360;
    _angle += delta;
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(end: _angle),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (context, angle, _) => Transform.rotate(
                angle: angle * math.pi / 180,
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _DialPainter(
                    bearing: widget.bearing,
                    tick: context.brand.textSecondary,
                    ring: context.brand.divider,
                    north: context.colors.error,
                    kaaba: brand.gold,
                    face: context.colors.surface.withValues(alpha: .35),
                  ),
                ),
              ),
            ),
            // Fixed pointer: the direction the phone is facing.
            Positioned(
              top: 0,
              child: Icon(
                Icons.arrow_drop_up_rounded,
                size: 44,
                color: widget.aligned ? brand.gold : context.colors.primary,
              ),
            ),
            AnimatedContainer(
              duration: AppMotion.medium,
              width: widget.size * 0.28,
              height: widget.size * 0.28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.aligned ? brand.hero : context.brand.surfaceMuted,
              ),
              child: Icon(
                Icons.mosque_rounded,
                size: widget.size * 0.13,
                color: widget.aligned ? brand.gold : context.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.bearing,
    required this.tick,
    required this.ring,
    required this.north,
    required this.kaaba,
    required this.face,
  });

  final double bearing;
  final Color tick;
  final Color ring;
  final Color north;
  final Color kaaba;
  final Color face;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 14;
    canvas.drawCircle(c, r, Paint()..color = face);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tickPaint = Paint()
      ..color = tick
      ..strokeCap = StrokeCap.round;
    for (var d = 0; d < 360; d += 5) {
      final major = d % 30 == 0;
      final a = (d - 90) * math.pi / 180;
      final outer = c + Offset(math.cos(a), math.sin(a)) * (r - 6);
      final inner =
          c + Offset(math.cos(a), math.sin(a)) * (r - (major ? 20 : 12));
      canvas.drawLine(inner, outer, tickPaint..strokeWidth = major ? 2.5 : 1);
    }

    // North marker.
    final n = Path()
      ..moveTo(c.dx, c.dy - r + 24)
      ..lineTo(c.dx - 9, c.dy - r + 44)
      ..lineTo(c.dx + 9, c.dy - r + 44)
      ..close();
    canvas.drawPath(n, Paint()..color = north);

    // Qibla needle from centre to the rim at the bearing.
    final qa = (bearing - 90) * math.pi / 180;
    final dir = Offset(math.cos(qa), math.sin(qa));
    canvas.drawLine(
      c + dir * (r * 0.2),
      c + dir * (r - 30),
      Paint()
        ..color = kaaba
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    final tip = c + dir * (r - 20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: tip, width: 22, height: 22),
        const Radius.circular(4),
      ),
      Paint()..color = kaaba,
    );
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.bearing != bearing ||
      old.tick != tick ||
      old.north != north ||
      old.kaaba != kaaba ||
      old.face != face;
}
