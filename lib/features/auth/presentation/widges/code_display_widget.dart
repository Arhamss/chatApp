import 'package:flutter/material.dart';

class CodeDisplayWidget extends StatelessWidget {
  const CodeDisplayWidget({super.key, required this.enteredCode});

  final String enteredCode;

  @override
  Widget build(BuildContext context) {
    final List<Widget> displayWidgets = [];

    for (int i = 0; i < 6; i++) {
      if (i < enteredCode.length) {
        displayWidgets.add(
          Text(
            enteredCode[i],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      } else {
        displayWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      }

      if (i < 5) {
        displayWidgets.add(
          const SizedBox(width: 20),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: displayWidgets,
    );
  }
}
