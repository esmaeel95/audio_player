import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/audio_player_bloc/audio_player_bloc.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AudioPlayerBloc audioPlayerBloc = context.read<AudioPlayerBloc>();
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
              builder: (context, state) {
                if (audioPlayerBloc.position.inSeconds.toDouble() >
                    audioPlayerBloc.duration.inSeconds.toDouble()) {
                  return const SizedBox.shrink();
                }
                return Slider(
                  value: audioPlayerBloc.position.inSeconds.toDouble(),
                  activeColor: Colors.pinkAccent,
                  inactiveColor: Colors.grey[600],
                  thumbColor: Colors.white,
                  min: 0,
                  max: audioPlayerBloc.duration.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayerBloc.player.seek(position);
                    setState(() {});
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
