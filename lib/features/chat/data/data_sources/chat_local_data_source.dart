import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:logging/logging.dart';

class ChatLocalDataSource {
  ChatLocalDataSource(this.sharedPreferencesHelper);

  final SharedPreferencesHelper sharedPreferencesHelper;
  final Logger logger = Logger('ChatLocalDataSourceImpl');

  Future<void> cacheChats(List<String> chats) async {
    try {
      await sharedPreferencesHelper.setStringList('cached_chats', chats);
    } catch (e, stackTrace) {
      logger.severe('Failed to cache chats', e, stackTrace);
    }
  }

  List<String>? getCachedChats() {
    try {
      return sharedPreferencesHelper.getStringList('cached_chats');
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached chats', e, stackTrace);
      return null;
    }
  }

  Future<void> cacheMessages(
    List<String> messages,
    String conversationId,
  ) async {
    try {
      await sharedPreferencesHelper.setStringList(
        'cached_messages_$conversationId',
        messages,
      );
    } catch (e, stackTrace) {
      logger.severe('Failed to cache messages', e, stackTrace);
    }
  }

  List<String>? getCachedMessages(
    String conversationId,
  ) {
    try {
      return sharedPreferencesHelper.getStringList(
        'cached_messages_$conversationId',
      );
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached messages', e, stackTrace);
      return null;
    }
  }

  String? getUserDetails(String userId) {
    try {
      return sharedPreferencesHelper.getString('user_details_$userId');
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached user details', e, stackTrace);
      return null;
    }
  }
}
