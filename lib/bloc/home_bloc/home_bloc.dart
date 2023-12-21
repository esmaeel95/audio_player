import 'package:audio_player/model/audio_player_data.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int indexScreen = 0;
  AudioPlayerData? selectedAudio;

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is NavBarIndexChanged) {
        emit(LoadingHome());
        indexScreen = event.index;
        emit(ChangedIndexNavBarSuccessful());
      }
      if (event is AddAudioInfo) {
        // when select the audio from list and this method for hold the audio object on all screen.
        emit(LoadingHome());
        selectedAudio = event.data;
        emit(AddAudioInfoSuccessful());
      }

      if (event is RefreshHome) {
        emit(LoadingRefresh());
        emit(RefreshSuccessful());
      }
    });
  }
}
