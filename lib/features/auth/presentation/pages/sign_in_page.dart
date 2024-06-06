import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:chat_app/core/widgets/numpad_widget.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _countryCodeController =
      TextEditingController(text: '+92');

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.23,
                  ),
                  const Text(
                    'Enter Your Phone Number',
                    style: TextStyle(
                      color: Color(0xFF0F1828),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Please confirm your country code and enter your phone number',
                    style: TextStyle(
                      color: Color(0xFF0F1828),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                CountryCodePicker(
                  onChanged: (countryCode) {
                    _countryCodeController.text = countryCode.dialCode!;
                  },
                  initialSelection: 'PK',
                  favorite: const ['+92', 'PK'],
                  boxDecoration: BoxDecoration(
                    color: const Color(0xFFF7F7FC),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String enteredPhoneNumber = '';
                      if (state is PhoneNumberEntryState) {
                        enteredPhoneNumber = state.enteredPhoneNumber;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            enteredPhoneNumber,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                return MainButton(
                  buttonText: 'Continue',
                  onTapAction: () {
                    final fullPhoneNumber =
                        '${_countryCodeController.text}${context.read<AuthBloc>().state is PhoneNumberEntryState ? (context.read<AuthBloc>().state as PhoneNumberEntryState).enteredPhoneNumber : ''}';
                    context
                        .read<AuthBloc>()
                        .add(PhoneNumberEntered(fullPhoneNumber));
                  },
                  isLoading: state is AuthLoading,
                );
              },
              listener: (context, state) {
                if (state is AuthCodeSent) {
                  context.goNamed(
                    AppRoute.signin_verification.name,
                    extra: state.verificationId,
                  );
                } else if (state is AuthError) {
                  _showToast(context, 'Error: ${state.message}');
                }
              },
            ),
            const CustomNumpad(inputType: NumpadInputType.phoneNumber),
          ],
        ),
      ),
    );
  }
}
