part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingHome extends HomeState {}

class ChangedIndexNavBarSuccessful extends HomeState {}

class AddAudioInfoSuccessful extends HomeState {}

class LoadingRefresh extends HomeState {}

class RefreshSuccessful extends HomeState {}
