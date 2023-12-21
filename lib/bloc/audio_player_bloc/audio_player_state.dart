part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class Loading extends AudioPlayerState {}

class LoadingPlayAudio extends AudioPlayerState {}

class ChangedSuccessful extends AudioPlayerState {}

class InitialSuccessful extends AudioPlayerState {}

class ErrorOccure extends AudioPlayerState {
  final String message;

  ErrorOccure(this.message);
}

class DurationChangedSuccessful extends AudioPlayerState {}

class PositionChangedSuccessful extends AudioPlayerState {}

class LoadingDurationChanged extends AudioPlayerState {}

class LoadingPositionChanged extends AudioPlayerState {}

class LoadingRefreshAudioPlayer extends AudioPlayerState {}

class RefreshAudioPlayerSuccessful extends AudioPlayerState {}
