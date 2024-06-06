import 'package:equatable/equatable.dart';

abstract class BottomNavBarEvent extends Equatable {
  const BottomNavBarEvent();

  @override
  List<Object> get props => [];
}

class UpdateTabIndex extends BottomNavBarEvent {
  final int index;

  const UpdateTabIndex(this.index);

  @override
  List<Object> get props => [index];
}
