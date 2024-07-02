import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key, required this.controller, required this.onSend, required this.onSendFile});

  final TextEditingController controller;
  final VoidCallback onSend;
  final Function onSendFile;

  void MakeVideo() async {

    final videoFile = await ImagePicker().pickVideo(source: ImageSource.camera);

    if(videoFile != null){
      print("Video file path: ${videoFile.path}");
      onSendFile(videoFile, true);
    }
    else{
      print("Video file not selected");
    }
  }

  void MakePhoto() async {

    final photoFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if(photoFile != null){
      print("Photo file path: ${photoFile.path}");
      onSendFile(photoFile, false);
       
    }
    else{
      print("Photo file not selected");
    }
  }

  void handleMenuClick(int item) {
    switch (item) {
      case 0:
        print("Camera clicked");
        // Handle camera action here
        MakePhoto();

        break;
      case 1:
        print("Video clicked");
        // Handle video action here
        MakeVideo();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            PopupMenuButton<int>(
              constraints: const BoxConstraints(
                      minWidth: 50, // minimum width for the menu item
                      maxWidth: 50, // maximum width for the menu item
                    ),
              icon: Icon(Icons.add),
              onSelected: (item) => handleMenuClick(item),
              itemBuilder: (context) => [

                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.black),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam, color: Colors.black),
                    ],
                  ),
                  ),
              ],
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                messageSend,
              ),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
