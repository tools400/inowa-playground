import 'package:flutter/material.dart';

/// Dieses Widget definiert die maximale Breite einer Text/Wert Kombination.
class SimpleConstrainedBox extends StatelessWidget {
  const SimpleConstrainedBox({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: child,
      );
}
