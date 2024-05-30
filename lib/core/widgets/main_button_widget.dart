import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.buttonText,
    required this.onTapAction,
    this.isLoading = false,
  });

  final String buttonText;
  final VoidCallback onTapAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading ? null : onTapAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002DE3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
