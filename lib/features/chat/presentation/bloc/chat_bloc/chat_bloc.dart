import 'package:bloc/bloc.dart';

import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/create_chat_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required this.getChatsUseCase, required this.createChatUsecase})
      : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
  }

  final GetChatsUseCase getChatsUseCase;
  final CreateChatUseCase createChatUsecase;

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await getChatsUseCase.call(event.userId);

    result.fold(
      (failure) => emit(ChatError(failure.toString())),
      (chats) => emit(ChatLoaded(chats)),
    );
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await createChatUsecase.call(
      [event.userId, event.senderId],
      event.message,
      event.senderId,
    );

    result.fold(
      (failure) => emit(ChatError(failure.toString())),
      (_) => null,
    );
  }
}
