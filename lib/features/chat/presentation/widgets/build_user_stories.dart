import 'package:chat_app/core/asset_names.dart';
import 'package:flutter/material.dart';

class StoriesListView extends StatelessWidget {
  StoriesListView({super.key});

  final List<Map<String, String>> stories = [
    {'image': arham, 'name': 'Arham'},
    {'image': arham, 'name': 'John'},
    {'image': arham, 'name': 'Doe'},
    {'image': arham, 'name': 'Max'},
    {'image': arham, 'name': 'Alex'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryButton();
          } else {
            return _buildStoryItem(stories[index - 1]);
          }
        },
      ),
    );
  }

  Widget _buildAddStoryButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 30, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text('Your Story', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStoryItem(Map<String, String> story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFFD2D5F9), Color(0xFF2C37E1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                4.0,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(story['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(story['name']!, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
