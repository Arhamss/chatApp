import 'package:flutter/material.dart';

class CustomNumpad extends StatelessWidget {
  const CustomNumpad({super.key, required this.controller});

  final TextEditingController controller;

  void _onKeyboardTap(String value) {
    controller.text = controller.text + value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          if (index < 9) {
            return _buildNumpadButton((index + 1).toString());
          } else if (index == 9) {
            return Container();
          } else if (index == 10) {
            return _buildNumpadButton('0');
          } else {
            return _buildBackspaceButton();
          }
        },
      ),
    );
  }

  Widget _buildNumpadButton(String value) {
    return GestureDetector(
      onTap: () => _onKeyboardTap(value),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: () {
        if (controller.text.isNotEmpty) {
          controller.text =
              controller.text.substring(0, controller.text.length - 1);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
