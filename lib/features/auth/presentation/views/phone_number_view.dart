import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:chat_app/core/widgets/numpad_widget.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class PhoneNumberView extends StatelessWidget {
  PhoneNumberView({super.key});

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
                    'enter_your_phone_number',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ).tr(),
                  const Text(
                    'please_confirm_your_country_code',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ).tr(),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              enteredPhoneNumber,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
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
                  buttonText: 'continue'.tr(),
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
                    AppRoute.verify.name,
                    extra: state.verificationId,
                  );
                } else if (state is AuthError) {
                  _showToast(
                    context,
                    'error'.tr() + state.message,
                  );
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
