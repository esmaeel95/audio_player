part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerEvent {}

class ChangePlayerIndex extends AudioPlayerEvent {
  final int index;

  ChangePlayerIndex({required this.index});
}

class InitialMedia extends AudioPlayerEvent {}

class DurationChange extends AudioPlayerEvent {
  final Duration duration;

  DurationChange({required this.duration});
}

class PositionChange extends AudioPlayerEvent {
  final Duration duration;

  PositionChange({required this.duration});
}

class RefreshAudioPlayer extends AudioPlayerEvent {}
