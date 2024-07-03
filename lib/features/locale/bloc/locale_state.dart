part of 'locale_bloc.dart';

abstract class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object> get props => [];
}

class LocaleInitial extends LocaleState {}

class LocaleLoaded extends LocaleState {
  const LocaleLoaded({required this.locale});

  final Locale locale;

  @override
  List<Object> get props => [locale];
}
