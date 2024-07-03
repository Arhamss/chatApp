import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'locale_event.dart';

part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInitial()) {
    on<ChangeLocaleEvent>((event, emit) {
      emit(LocaleLoaded(locale: event.locale));
    });
    on<LoadDeviceLocaleEvent>((event, emit) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      emit(LocaleLoaded(locale: deviceLocale));
    });
  }
}
