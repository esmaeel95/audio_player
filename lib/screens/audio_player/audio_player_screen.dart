import 'package:audio_player/bloc/audio_player_bloc/audio_player_bloc.dart';
import 'package:audio_player/bloc/home_bloc/home_bloc.dart';
import 'package:audio_player/constant_widget/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyAudio extends StatelessWidget {
  const MyAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyAudioPlayer();
  }
}

class MyAudioPlayer extends StatelessWidget {
  const MyAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    AudioPlayerBloc audioPlayerBloc = context.read<AudioPlayerBloc>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('All songs'),
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        backgroundColor: bgColor,
      ),
      body: BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
        listener: (context, state) {
          if (state is ChangedSuccessful) {
            context.read<HomeBloc>().add(AddAudioInfo(
                data: audioPlayerBloc.allMedia[audioPlayerBloc.currentIndex]));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Getting songs',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: audioPlayerBloc.allMedia.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 200),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        decoration: BoxDecoration(
                            color: audioPlayerBloc.currentIndex == index
                                ? Colors.grey.withOpacity(0.3)
                                : null,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            audioPlayerBloc.allMedia[index].title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            audioPlayerBloc.allMedia[index].subTitle,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          leading: getAudioIcon(index, context),
                          trailing: Text(
                            audioPlayerBloc.allMedia[index].duration,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () async {
                            if (audioPlayerBloc.currentIndex != index) {
                              audioPlayerBloc
                                  .add(ChangePlayerIndex(index: index));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget getAudioIcon(int index, BuildContext context) {
    if (context.read<AudioPlayerBloc>().currentIndex != index) {
      return Container(
        width: 50,
        height: 50,
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(
          Icons.play_arrow_sharp,
          color: Colors.pinkAccent,
        ),
      );
    }
    return Container(
      width: 50,
      height: 50,
      decoration:
          const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle),
      child: const Icon(
        Icons.pause,
        color: Colors.white,
      ),
    );
  }
}
