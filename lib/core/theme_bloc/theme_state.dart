part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({required this.themeData});

  final ThemeData themeData;

  @override
  List<Object?> get props => [themeData];
}

class ThemeChanged extends ThemeState {
  const ThemeChanged({required this.themeData});

  final ThemeData themeData;

  @override
  List<Object?> get props => [themeData];
}
