import 'package:flutter/material.dart';

class SettingsSegmentedButton<T> extends StatelessWidget {
  const SettingsSegmentedButton({
    super.key,
    required this.initialSelection,
    required this.buttonSegments,
    this.onSelectionChanged,
  });

  final Set<T> initialSelection;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final Set<T> buttonSegments;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
        segments: buttonSegments
            .map((item) => ButtonSegment(
                  value: item,
                  label: Text(item.toString()),
                ))
            .toList(),
        selected: initialSelection,
        onSelectionChanged: onSelectionChanged);
  }
}
