import 'package:flutter/material.dart';

import 'package:inowa/src/ui/widgets/widgets.dart';

/// Dieses Widget erzeugt ein Textfeld.
/// See also: https://api.flutter.dev/flutter/material/TextTheme-class.html
class SimpleNonEditableText extends StatefulWidget {
  const SimpleNonEditableText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<SimpleNonEditableText> createState() => _SimpleText();
}

class _SimpleText extends State<SimpleNonEditableText> {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: widgetWidth,
        child: Text(widget.text, style: TextTheme.of(context).bodyLarge),
      );
}
