import 'package:bloc/bloc.dart';
import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/load_chat_message_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.sendMessageUseCase,
    required this.loadChatMessageUseCase,
    required this.getUserByIdUseCase,
  }) : super(MessageLoading()) {
    on<LoadChatMessageEvent>(_onLoadChatMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  final SendMessageUseCase sendMessageUseCase;
  final LoadChatMessageUseCase loadChatMessageUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final List<MessageEntity> _messages = [];

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      // Temporary ID
      senderId: event.senderId,
      text: event.text,
      timestamp: DateTime.now(),
      type: 'text',
    );
    _messages.insert(0, msg);
    // #TODO
    // emit(MessageLoaded(_messages));

    final result = await sendMessageUseCase.call(
      event.senderId,
      event.text,
      event.conversationId,
    );

    result.fold(
      (failure) {
        _messages.remove(msg);
        emit(MessageError(failure.toString()));
      },
      (_) {},
    );
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final messagesStream = loadChatMessageUseCase.call(event.conversationId);
    final userResult = await getUserByIdUseCase.call(
      event.receiverId,
    );
    userResult.fold(
      (failure) => MessageError(failure.toString()),
      (user) async {
        await emit.forEach<Either<Failure, List<MessageEntity>>>(
          messagesStream,
          onData: (result) => result.fold(
            (failure) => MessageError(failure.toString()),
            (data) {
              return MessageLoaded(
                data,
                user,
              );
            },
          ),
          onError: (error, stackTrace) => MessageError(error.toString()),
        );
      },
    );
  }
}
