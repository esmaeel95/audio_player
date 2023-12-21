import 'package:audio_player/bloc/audio_player_bloc/audio_player_bloc.dart';
import 'package:audio_player/constant_widget/widgets/custom_component_nav_bar_widget.dart';
import 'package:audio_player/constant_widget/widgets/follow_widget.dart';
import 'package:audio_player/constant_widget/widgets/image_widget.dart';
import 'package:audio_player/constant_widget/widgets/media_icon_widget.dart';
import 'package:audio_player/constant_widget/widgets/shuffle_widget.dart';
import 'package:audio_player/constant_widget/widgets/slider_widget.dart';
import 'package:audio_player/screens/podcast/podcast_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc/home_bloc.dart';
import '../screens/audio_player/audio_player_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/setting/setting_screen.dart';
import 'color/colors.dart';
import 'widgets/media_icon.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AudioPlayerBloc audioPlayerBloc = context.read<AudioPlayerBloc>();
    audioPlayerBloc.player.onPlayerComplete.listen((event) async {
      await audioPlayerBloc.player.seek(Duration.zero);
      await audioPlayerBloc.player.pause();
      audioPlayerBloc.add(DurationChange(duration: Duration.zero));
      audioPlayerBloc.add(PositionChange(duration: Duration.zero));
    });
    audioPlayerBloc.player.onDurationChanged.listen((event) {
      audioPlayerBloc.add(DurationChange(duration: event));
    });
    audioPlayerBloc.player.onPositionChanged.listen((event) {
      audioPlayerBloc.add(PositionChange(duration: event));
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = context.read<HomeBloc>();
    return Scaffold(
      backgroundColor: bgColor,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: homeBloc.selectedAudio == null ? 65 : 65 + 65),
                child: _buildScreens()[homeBloc.indexScreen],
              ),
              if (homeBloc.selectedAudio != null)
                audioInfoWidget(context, homeBloc),
              navBarWidgets(context, homeBloc),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const MyAudio(),
      const SearchScreen(),
      const PodcastScreen(),
      const SettingScreen(),
    ];
  }

  Widget audioInfoWidget(BuildContext context, HomeBloc homeBloc) {
    return BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
      listener: (context, state) {
        if (state is ChangedSuccessful) {
          homeBloc.add(AddAudioInfo(
              data: context
                  .read<AudioPlayerBloc>()
                  .allMedia[context.read<AudioPlayerBloc>().currentIndex]));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {
              AudioPlayerBloc audioPlayerBloc = context.read<AudioPlayerBloc>();
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isDismissible: false,
                isScrollControlled: true,
                builder: (contextSheet) {
                  return BlocProvider.value(
                      value: context.read<AudioPlayerBloc>(),
                      child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                        builder: (context, state) {
                          return bottomSheetContent(
                              homeBloc, context, audioPlayerBloc);
                        },
                      ));
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 65),
              child: Container(
                height: 65,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      tileMode: TileMode.mirror,
                      colors: gradientColor,
                    )),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(children: [
                  ImageWidget(url: homeBloc.selectedAudio!.image),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Text(
                      homeBloc.selectedAudio!.title,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    onPressed: () async {
                      AudioPlayerBloc audioBloc =
                          context.read<AudioPlayerBloc>();
                      if (audioBloc.player.state == PlayerState.paused) {
                        if (audioBloc.duration == Duration.zero) {
                          await audioBloc.player
                              .play(UrlSource(homeBloc.selectedAudio!.url));
                        } else {
                          await audioBloc.player.resume();
                        }
                      } else {
                        await audioBloc.player.pause();
                      }
                      homeBloc.add(RefreshHome());
                    },
                    icon: Icon(
                      context.read<AudioPlayerBloc>().player.state !=
                              PlayerState.paused
                          ? Icons.pause
                          : Icons.play_arrow_sharp,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    onPressed: () {
                      AudioPlayerBloc audioBloc =
                          context.read<AudioPlayerBloc>();
                      // audioBloc.player.state
                      audioBloc.add(
                          ChangePlayerIndex(index: audioBloc.currentIndex + 1));
                      homeBloc.add(RefreshHome());
                    },
                    icon: const Icon(
                      Icons.skip_next_sharp,
                      size: 40,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheetContent(HomeBloc homeBloc, BuildContext context,
      AudioPlayerBloc audioPlayerBloc) {
    return Stack(
      children: [
        const SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
        ).blurred(blurColor: Colors.black, blur: 12),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            headerWidget(context),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 10),
              child: ClipOval(
                  child: ImageWidget(url: homeBloc.selectedAudio!.image)),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 30),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FollowWidget(),
                  ShuffleWidget(),
                ],
              ),
            ),
            titleWidget(context, homeBloc),
            subTitleWidget(context, homeBloc),
            timeAndSliderInfoWidget(context, audioPlayerBloc),
            playPauseBottonsButtomSheet(context, audioPlayerBloc, homeBloc),
          ],
        ),
      ],
    );
  }

  Widget playPauseBottonsButtomSheet(BuildContext context,
      AudioPlayerBloc audioPlayerBloc, HomeBloc homeBloc) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomMediaIconWidget(icon: Icons.skip_previous),
          const CustomMediaIconWidget(icon: Icons.skip_previous),
          Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
                onPressed: () async {
                  if (audioPlayerBloc.player.state == PlayerState.paused) {
                    if (audioPlayerBloc.duration == Duration.zero) {
                      await audioPlayerBloc.player
                          .play(UrlSource(homeBloc.selectedAudio!.url));
                    } else {
                      await audioPlayerBloc.player.resume();
                    }
                  } else {
                    await audioPlayerBloc.player.pause();
                  }
                  homeBloc.add(RefreshHome());
                  audioPlayerBloc.add(RefreshAudioPlayer());
                },
                icon: Icon(
                  audioPlayerBloc.player.state != PlayerState.paused
                      ? Icons.pause
                      : Icons.play_arrow_sharp,
                  size: 50,
                )),
          ),
          const CustomMediaIconWidget(icon: Icons.skip_next),
          const CustomMediaIconWidget(icon: Icons.skip_next),
        ],
      ),
    );
  }

  Padding headerWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.grey[400],
              )),
          Text(
            'Now Playing',
            style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.grey[400],
              )),
        ],
      ),
    );
  }

  Widget navBarWidgets(BuildContext context, HomeBloc homeBloc) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 65,
        child: Container(
            decoration: const BoxDecoration(
              color: navBarColor,
            ),
            child: Row(
              children: [
                CustomComponentNavBarWidget(
                    icon: Icons.home_outlined,
                    color: homeBloc.indexScreen == 0
                        ? Colors.pinkAccent
                        : navBarColor,
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(NavBarIndexChanged(index: 0));
                    }),
                CustomComponentNavBarWidget(
                    icon: Icons.search,
                    color: homeBloc.indexScreen == 1
                        ? Colors.pinkAccent
                        : navBarColor,
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(NavBarIndexChanged(index: 1));
                    }),
                const HeadphonesIconWidget(),
                CustomComponentNavBarWidget(
                    icon: Icons.wifi_tethering,
                    color: homeBloc.indexScreen == 2
                        ? Colors.pinkAccent
                        : navBarColor,
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(NavBarIndexChanged(index: 2));
                    }),
                CustomComponentNavBarWidget(
                    icon: Icons.settings,
                    color: homeBloc.indexScreen == 3
                        ? Colors.pinkAccent
                        : navBarColor,
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(NavBarIndexChanged(index: 3));
                    }),
              ],
            )),
      ),
    );
  }

  Padding timeAndSliderInfoWidget(
      BuildContext context, AudioPlayerBloc audioPlayerBloc) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              audioPlayerBloc.getDuration(audioPlayerBloc.position),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 15),
            ),
            const Expanded(
              child: SliderWidget(),
            ),
            Text(
              audioPlayerBloc.getDuration(audioPlayerBloc.duration),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Padding subTitleWidget(BuildContext context, HomeBloc homeBloc) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 60),
      child: Text(
        homeBloc.selectedAudio!.subTitle,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15),
      ),
    );
  }

  Padding titleWidget(BuildContext context, HomeBloc homeBloc) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 15),
      child: Text(
        homeBloc.selectedAudio!.title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
      ),
    );
  }
}
