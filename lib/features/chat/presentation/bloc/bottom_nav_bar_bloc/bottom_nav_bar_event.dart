import 'package:equatable/equatable.dart';

abstract class BottomNavBarEvent extends Equatable {
  const BottomNavBarEvent();

  @override
  List<Object> get props => [];
}

class UpdateTabIndex extends BottomNavBarEvent {
  const UpdateTabIndex(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}
