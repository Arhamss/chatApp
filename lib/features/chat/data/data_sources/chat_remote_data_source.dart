import 'package:chat_app/features/chat/data/models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ChatModel>> getChats() async {
    // Mock data for demonstration. Replace this with actual data fetching logic.
    return [
      ChatModel(
        id: '1',
        name: 'Athalia Putri',
        lastMessage: 'Good morning, did you sleep well?',
        profilePictureUrl: 'https://example.com/image1.jpg',
        lastMessageTime: DateTime.now(),
        unreadCount: 1,
      ),
      ChatModel(
        id: '2',
        name: 'Raki Devon',
        lastMessage: 'How is it going?',
        profilePictureUrl: 'https://example.com/image2.jpg',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
        unreadCount: 0,
      ),
      // Add more chat data here...
    ];
  }
}
