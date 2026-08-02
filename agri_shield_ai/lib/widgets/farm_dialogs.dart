import 'package:flutter/material.dart';
import '../theme/farm_theme.dart';

Future<void> showFarmDialog(
  BuildContext context, {
  required String title,
  required String body,
  String confirmLabel = 'OK',
  VoidCallback? onConfirm,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: FarmColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text(
        body,
        style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close',
              style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        if (onConfirm != null)
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(confirmLabel),
          ),
      ],
    ),
  );
}

void showFarmSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.w700)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
