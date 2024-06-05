import 'package:bloc/bloc.dart';
import 'package:chat_app/core/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial(themeData: AppThemes().lightTheme)) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final currentState = state;
    if (currentState is ThemeInitial || currentState is ThemeChanged) {
      final newThemeData = AppThemes().lightTheme;
      // final newThemeData = currentState.themeData.brightness == Brightness.dark
      //     ? AppThemes().lightTheme
      //     : AppThemes().darkTheme;
      emit(ThemeChanged(themeData: newThemeData));
    }
  }
}
