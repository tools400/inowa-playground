import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BluetoothIcon extends StatelessWidget {
  const BluetoothIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 32,
        height: 32,
        child: Align(alignment: Alignment.center, child: Icon(Icons.bluetooth)),
      );
}

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
}

class VSpace extends StatelessWidget {
  const VSpace({Key? key, this.flex = 1}) : super(key: key);

  final double flex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10 * flex,
        ),
      ],
    );
  }
}

class HSpace extends StatelessWidget {
  const HSpace({Key? key, this.flex = 1}) : super(key: key);

  final double flex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 10 * flex,
        ),
      ],
    );
  }
}

/// Dieses Widget erzeugt ein Label mit einem Link.
class UrlLink extends StatelessWidget {
  const UrlLink({
    super.key,
    this.label,
    this.url,
  });

  final String? label;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(url!);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: url,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri(
                  scheme: uri.scheme,
                  host: uri.host,
                ));
              },
          ),
        ],
      ),
    );
  }
}
