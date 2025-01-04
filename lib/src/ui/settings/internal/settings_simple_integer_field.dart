import 'package:flutter/material.dart';

import 'package:inowa/src/ui/widgets/widgets.dart';

/// Dieses Widget erzeugt ein Eingabefeld.
class SimpleInteger extends StatefulWidget {
  const SimpleInteger(
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
  State<SimpleInteger> createState() => _SimpleText();
}

class _SimpleText extends State<SimpleInteger> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 200,
        height: 50,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
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

/*
        validator: (value) => value != null && value.isNotEmpty
            ? null
            : AppLocalizations.of(context)!.required,

*/
