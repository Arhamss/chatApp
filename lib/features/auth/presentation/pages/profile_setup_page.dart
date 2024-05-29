import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSetupPage extends StatelessWidget {
  ProfileSetupPage({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                ),
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF7F7FC),
                labelText: 'First Name (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF7F7FC),
                labelText: 'Last Name (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return MainButton(
                  buttonText: 'Save',
                  onTapAction: () {
                    final firstName = _firstNameController.text;
                    final lastName = _lastNameController.text;
                    context
                        .read<ProfileBloc>()
                        .add(SaveProfile(firstName, lastName));
                  },
                  isLoading: state is ProfileSaving,
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileSaveSuccess) {
                  return const Text('Profile saved successfully!');
                } else if (state is ProfileSaveFailure) {
                  return Text('Error: ${state.message}');
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
