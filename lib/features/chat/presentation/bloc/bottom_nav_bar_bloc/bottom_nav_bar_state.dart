import 'package:equatable/equatable.dart';

abstract class BottomNavBarState extends Equatable {
  const BottomNavBarState();

  @override
  List<Object> get props => [];
}

class BottomNavBarUpdated extends BottomNavBarState {
  const BottomNavBarUpdated(this.selectedIndex);

  final int selectedIndex;

  @override
  List<Object> get props => [selectedIndex];
}
