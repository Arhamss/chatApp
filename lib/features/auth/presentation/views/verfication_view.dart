import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:chat_app/core/widgets/numpad_widget.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/widges/code_display_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key, required this.verificationId});

  final String verificationId;

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String enteredCode = '';
                if (state is CodeEntryState) {
                  enteredCode = state.enteredCode;
                }
                return CodeDisplayWidget(enteredCode: enteredCode);
              },
            ),
            Column(
              children: [
                const CustomNumpad(inputType: NumpadInputType.verificationCode),
                const SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return MainButton(
                      buttonText: 'verify'.tr(),
                      onTapAction: () {
                        final code = context.read<AuthBloc>().state
                                is CodeEntryState
                            ? (context.read<AuthBloc>().state as CodeEntryState)
                                .enteredCode
                            : '';
                        context
                            .read<AuthBloc>()
                            .add(CodeEntered(verificationId, code));
                      },
                      isLoading: state is AuthLoading,
                    );
                  },
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      context.goNamed(AppRoute.profileSetup.name);
                    } else if (state is AuthError) {
                      _showToast(context, 'error'.tr() + state.message);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
