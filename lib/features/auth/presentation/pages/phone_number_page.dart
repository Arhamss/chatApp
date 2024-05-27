import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberPage extends StatelessWidget {
  PhoneNumberPage({super.key});

  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Enter Your Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(PhoneNumberEntered(_phoneController.text));
              },
              child: const Text('Continue'),
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
          ],
        ),
      ),
    );
  }
}
