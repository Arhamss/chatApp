import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileSection extends StatelessWidget {
  final String avatarAsset;
  final String name;
  final String phoneNumber;

  ProfileSection({
    required this.avatarAsset,
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            child: SvgPicture.asset(
              avatarAsset,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF0F1828),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32.0),
          SvgPicture.asset('assets/right_arrow.svg'),
        ],
      ),
    );
  }
}
