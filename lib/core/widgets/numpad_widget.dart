import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NumpadInputType { phoneNumber, verificationCode }

class CustomNumpad extends StatelessWidget {
  const CustomNumpad({super.key, required this.inputType});

  final NumpadInputType inputType;

  void _onKeyboardTap(BuildContext context, String value) {
    if (inputType == NumpadInputType.phoneNumber) {
      context.read<AuthBloc>().add(AddPhoneNumberDigit(value));
    } else if (inputType == NumpadInputType.verificationCode) {
      context.read<AuthBloc>().add(AddDigit(value));
    }
  }

  void _onBackspaceTap(BuildContext context) {
    if (inputType == NumpadInputType.phoneNumber) {
      context.read<AuthBloc>().add(const RemovePhoneNumberDigit());
    } else if (inputType == NumpadInputType.verificationCode) {
      context.read<AuthBloc>().add(const RemoveDigit());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 24,
        ),
        itemBuilder: (context, index) {
          if (index < 9) {
            return _buildNumpadButton(context, (index + 1).toString());
          } else if (index == 9) {
            return Container();
          } else if (index == 10) {
            return _buildNumpadButton(context, '0');
          } else {
            return _buildBackspaceButton(context);
          }
        },
      ),
    );
  }

  Widget _buildNumpadButton(BuildContext context, String value) {
    return ElevatedButton(
      onPressed: () => _onKeyboardTap(context, value),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF7F7FC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        elevation: 0,
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _onBackspaceTap(context),
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
          ),
        ),
      ),
    );
  }
}
