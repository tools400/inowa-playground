import 'package:flutter/material.dart';

import 'package:inowa/src/ui/widgets/widgets.dart';

/// Dieses Widget erzeugt ein Eingabefeld.
class SimpleEditableText extends StatefulWidget {
  const SimpleEditableText({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.validator,
    this.autofillHints,
    this.focusNode,
  });

  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;

  @override
  State<SimpleEditableText> createState() => _SimpleText();
}

class _SimpleText extends State<SimpleEditableText> {
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
          focusNode: widget.focusNode,
        ),
      );

  void _onChanged(String value) {
    widget.controller?.text = value;
  }
}
