part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class NavBarIndexChanged extends HomeEvent {
  final int index;

  NavBarIndexChanged({required this.index});
}

class AddAudioInfo extends HomeEvent {
  final AudioPlayerData data;

  AddAudioInfo({required this.data});
}

class RefreshHome extends HomeEvent {}
