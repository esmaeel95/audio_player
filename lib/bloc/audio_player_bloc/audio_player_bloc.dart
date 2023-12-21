import 'package:audio_player/model/audio_player_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  int currentIndex = -1;
  double value = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  List<AudioPlayerData> allMedia = [];
  final player = AudioPlayer();

  AudioPlayerBloc() : super(AudioPlayerInitial()) {
    on<AudioPlayerEvent>((event, emit) async {
      if (event is ChangePlayerIndex) {
        try {
          emit(LoadingPlayAudio());
          currentIndex = event.index;
          if (currentIndex == allMedia.length) {
            currentIndex = 0;
            await player.play(UrlSource(allMedia[currentIndex].url));
          } else {
            await player.play(UrlSource(allMedia[currentIndex].url));
          }
          emit(ChangedSuccessful());
        } on Exception catch (e) {
          emit(ErrorOccure('you have an error'));
        }
      }

      if (event is InitialMedia) {
        emit(Loading());
        for (int i = 1; i < 18; i++) {
          final playerInit = AudioPlayer();
          await playerInit.setSource(UrlSource(
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$i.mp3'));
          Duration? duration = await playerInit.getDuration();
          allMedia.add(AudioPlayerData(
            subTitle: 'subtitle $i',
            url:
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$i.mp3',
            image: 'https://picsum.photos/250?image=$i',
            title: 'title $i',
            duration: getDuration(duration ?? const Duration()),
          ));
          await playerInit.dispose();
        }
        emit(InitialSuccessful());
      }
      if (event is DurationChange) {
        emit(LoadingDurationChanged());
        duration = event.duration;
        emit(DurationChangedSuccessful());
      }
      if (event is PositionChange) {
        emit(PositionChangedSuccessful());
        position = event.duration;
        emit(LoadingPositionChanged());
      }

      if (event is RefreshAudioPlayer) {
        emit(LoadingRefreshAudioPlayer());
        emit(RefreshAudioPlayerSuccessful());
      }
    });
  }

  String getDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
