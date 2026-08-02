import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../l10n/farm_l10n.dart';
import '../models/farm_models.dart';
import '../providers/farm_controller.dart';
import '../theme/farm_theme.dart';
import '../widgets/farm_dialogs.dart';
import '../widgets/farm_widgets.dart';

class LiveFeedScreen extends StatelessWidget {
  const LiveFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctrl = context.watch<FarmController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.liveFeedCamera(ctrl.cameraIndex + 1)),
        actions: [
          IconButton(
            tooltip: ctrl.flashOn ? l10n.flashOff : l10n.flashOn,
            onPressed: () {
              ctrl.toggleFlash();
              showFarmSnack(
                context,
                ctrl.flashOn ? l10n.flashTurnedOn : l10n.flashTurnedOff,
              );
            },
            icon: Icon(
              ctrl.flashOn
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
              color: ctrl.flashOn ? FarmColors.terracotta : null,
            ),
          ),
          IconButton(
            tooltip: ctrl.recording ? l10n.stopRecording : l10n.record,
            onPressed: () {
              ctrl.toggleRecording();
              showFarmSnack(
                context,
                ctrl.recording
                    ? l10n.recordingStarted
                    : l10n.recordingStopped,
              );
            },
            icon: Icon(
              ctrl.recording
                  ? Icons.stop_circle_rounded
                  : Icons.fiber_manual_record_rounded,
              color: ctrl.recording ? FarmColors.danger : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      transform: Matrix4.diagonal3Values(
                          ctrl.zoom, ctrl.zoom, 1.0),
                      transformAlignment: Alignment.center,
                      color: ctrl.flashOn
                          ? const Color(0xFF6B7D5A)
                          : const Color(0xFF4A5D3A),
                      child: const Center(
                        child: Icon(Icons.videocam_rounded,
                            size: 64, color: Color(0x66FFFFFF)),
                      ),
                    ),
                    if (ctrl.recording)
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: FarmColors.danger,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  size: 10, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'REC',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      left: 48,
                      top: 80,
                      width: 190,
                      height: 150,
                      child: GestureDetector(
                        onTap: () => showFarmDialog(
                          context,
                          title: FarmData.liveAnimal.localizedName(l10n),
                          body:
                              '${l10n.confidenceLabel(l10n.confidenceVerySure)}\n\n'
                              '${l10n.openActivateHint}',
                          confirmLabel: l10n.goToActivate,
                          onConfirm: () => context.push('/activate'),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: FarmColors.caution, width: 3),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: FarmColors.card,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    FarmData.liveAnimal.localizedName(l10n),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: FarmColors.text,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: FarmColors.softAmber,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      l10n.confidenceVerySure,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: FarmColors.terracotta,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: FarmColors.softGreen,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: ctrl.isFiring
                    ? () => context.push('/activate')
                    : () => showFarmSnack(context, l10n.nothingActive),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.volume_up_rounded,
                          color: FarmColors.forest),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ctrl.isFiring
                              ? '${l10n.aiScanning}: ${ctrl.activeEquipment!.shortName(l10n)}'
                              : l10n.nothingActive,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: FarmColors.forest,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: FarmColors.forest),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: BigLabeledButton(
                        icon: Icons.cameraswitch_rounded,
                        label: l10n.switchCam,
                        onTap: () {
                          ctrl.switchCamera();
                          showFarmSnack(
                            context,
                            l10n.switchedCamera(ctrl.cameraIndex + 1),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            l10n.zoomLabel(ctrl.zoom.toStringAsFixed(1)),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Slider(
                            value: ctrl.zoom,
                            min: 1,
                            max: 3,
                            divisions: 8,
                            label: '${ctrl.zoom.toStringAsFixed(1)}x',
                            onChanged: ctrl.setZoom,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BigLabeledButton(
                        icon: Icons.photo_camera_rounded,
                        label: l10n.snapshot,
                        onTap: () {
                          ctrl.takeSnapshot();
                          showFarmSnack(
                            context,
                            l10n.photoSaved(ctrl.snapshotCount),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
