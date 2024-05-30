import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;

  ChatBloc({required this.getChatsUseCase}) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await getChatsUseCase();

    result.fold(
      (failure) => emit(ChatError(failure.toString())),
      (chats) => emit(ChatLoaded(chats)),
    );
  }
}
