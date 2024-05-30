import 'package:chat_app/core/shared_preferences_helper.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<String> chats);

  List<String>? getCachedChats();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  ChatLocalDataSourceImpl(this.sharedPreferencesHelper);

  final SharedPreferencesHelper sharedPreferencesHelper;

  @override
  Future<void> cacheChats(List<String> chats) async {
    await sharedPreferencesHelper.setStringList('cached_chats', chats);
  }

  @override
  List<String>? getCachedChats() {
    return sharedPreferencesHelper.getStringList('cached_chats');
  }
}
