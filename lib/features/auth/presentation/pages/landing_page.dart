import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/asset_image_widget.dart';
import 'package:chat_app/core/widgets/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Center(
                child: AssetImageWidget(
                  assetPath: landingPage,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(72, 32, 72, 16),
                child: Text(
                  'Connect easily with your family and friends over countries',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse('https://www.google.com');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: const Text(
                    'Terms & Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              MainButton(
                buttonText: 'Sign In',
                onTapAction: () {
                  context.goNamed(AppRoute.signin.name);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MainButton(
                buttonText: 'Start Messaging',
                onTapAction: () {
                  context.goNamed(AppRoute.phone.name);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
