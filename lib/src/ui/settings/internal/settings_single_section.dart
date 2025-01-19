import 'package:flutter/material.dart';

import 'package:inowa/src/ui/widgets/widgets.dart';

class SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const SingleSection({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: sectionBorder,
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
