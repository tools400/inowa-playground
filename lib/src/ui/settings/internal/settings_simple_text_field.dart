import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

/// Dieses Widget erzeugt ein Eingabefeld.
class SimpleText extends StatefulWidget {
  const SimpleText({super.key, required this.controller, this.hintText});

  final String? hintText;
  final TextEditingController controller;

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
          onChanged: (value) {
            widget.controller.text = value;
          },
          decoration: inputDecoration(hintText: widget.hintText),
        ),
      );
}
