import 'package:bloc/bloc.dart';
import 'package:chat_app/core/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
          const ThemeState(
            themeMode: ThemeMode.light,
          ),
        ) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    emit(
      ThemeState(
        themeMode: state.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );
  }
}
