import 'package:bloc/bloc.dart';
import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'chat_home_event.dart';

part 'chat_home_state.dart';

class ChatHomeBloc extends Bloc<ChatHomeEvent, ChatHomeState> {
  ChatHomeBloc({
    required this.getChatsUseCase,
    required this.getUserByIdUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<NavigationToChatScreenEvent>(_onNavigationToChatScreen);
  }

  final GetChatsUseCase getChatsUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatHomeState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final Stream<Either<Failure, List<ConversationEntity>>> chatsStream =
          getChatsUseCase.call(event.userId);
      await for (final result in chatsStream) {
        result.fold(
          (failure) {
            emit(ChatError(failure.toString()));
          },
          (data) async {
            final List<UserEntity> users = [];

            for (final e in data) {
              final userResult =
                  await getUserByIdUseCase.call(e.participants[1]);
              userResult.fold(
                (failure) {
                  emit(ChatError(failure.toString()));
                  return;
                },
                (user) => users.add(user),
              );
            }
            print(users);
            emit(ChatLoaded(data, users));
          },
        );
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onNavigationToChatScreen(
    NavigationToChatScreenEvent event,
    Emitter<ChatHomeState> emit,
  ) async {
    emit(
      NavigateToChatScreen(
        event.chatId,
        event.receiverId,
      ),
    );
  }
}
