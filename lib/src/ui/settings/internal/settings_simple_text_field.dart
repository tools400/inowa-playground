import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';

/// Dieses Widget erzeugt ein Eingabefeld.
class SimpleText extends StatefulWidget {
  const SimpleText(
      {super.key, required this.controller, this.hintText, this.onChanged});

  final String? hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  State<SimpleText> createState() => _SimpleText();
}

class _SimpleText extends State<SimpleText> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 200,
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged ?? _onChanged,
          decoration: inputDecoration(hintText: widget.hintText),
        ),
      );

  void _onChanged(String value) {
    widget.controller.text = value;
  }
}
