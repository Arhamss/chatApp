import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:chat_app/core/widgets/numpad_widget.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberPage extends StatelessWidget {
  PhoneNumberPage({super.key});

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController =
      TextEditingController(text: '+92');

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
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF7F7FC),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            MainButton(
              buttonText: 'Continue',
              onTapAction: () {
                final fullPhoneNumber =
                    '${_countryCodeController.text}${_phoneController.text}';
                context
                    .read<AuthBloc>()
                    .add(PhoneNumberEntered(fullPhoneNumber));
              },
            ),
            BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthError) {
                  return Text('Error: ${state.message}');
                } else {
                  return Container();
                }
              },
              listener: (context, state) {
                if (state is AuthCodeSent) {
                  Navigator.pushNamed(context, '/verify');
                }
              },
            ),
            CustomNumpad(controller: _phoneController),
          ],
        ),
      ),
    );
  }
}
