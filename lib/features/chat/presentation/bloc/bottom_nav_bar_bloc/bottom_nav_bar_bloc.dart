import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(const BottomNavBarUpdated(1)) {
    on<UpdateTabIndex>((event, emit) {
      emit(BottomNavBarUpdated(event.index));
    });
  }
}
