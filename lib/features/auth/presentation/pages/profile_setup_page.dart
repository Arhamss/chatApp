import 'dart:io';

import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupPage extends StatelessWidget {
  ProfileSetupPage({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    String photoPath = '';
                    if (state is ImagePickedState) {
                      photoPath = state.imagePath;
                    }

                    return GestureDetector(
                      onTap: () {
                        context.read<ProfileBloc>().add(PickImageEvent());
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: photoPath.isNotEmpty
                            ? FileImage(File(photoPath))
                            : null,
                        child: photoPath.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                    );
                  },
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
                labelText: 'First Name (Required)',
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
            BlocConsumer<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return MainButton(
                  buttonText: 'Save',
                  onTapAction: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final userModel = UserModel(
                        id: user.uid,
                        phoneNumber: user.phoneNumber ?? '03068555581',
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        photoUrl:
                            (state is ImagePickedState) ? state.imagePath : '',
                      );
                      context
                          .read<ProfileBloc>()
                          .add(SaveProfileEvent(userModel));
                    }
                  },
                  isLoading: state is ProfileSaving,
                );
              },
              listener: (BuildContext context, ProfileState state) {
                if (state is ProfileSaveSuccess) {
                  context.goNamed(AppRoute.chatHome.name);
                } else if (state is ProfileSaveFailure) {
                  _showToast(context, 'Error: ${state.message}');
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
