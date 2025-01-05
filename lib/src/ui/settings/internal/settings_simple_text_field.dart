import 'package:flutter/material.dart';

import 'package:inowa/src/ui/widgets/widgets.dart';

/// Dieses Widget erzeugt ein Eingabefeld.
class SimpleText extends StatefulWidget {
  const SimpleText(
      {super.key,
      required this.controller,
      this.hintText,
      this.onChanged,
      this.validator,
      this.autofillHints});

  final String? hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final Iterable<String>? autofillHints;

  @override
  State<SimpleText> createState() => _SimpleText();
}

class _SimpleText extends State<SimpleText> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widgetWidth,
        child: TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged ?? _onChanged,
          decoration: inputDecoration(hintText: widget.hintText),
          autofillHints: widget.autofillHints,
          validator: widget.validator,
        ),
      );

  void _onChanged(String value) {
    widget.controller.text = value;
  }
}
