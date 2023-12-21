class AudioPlayerData {
  final String url;
  final String duration;
  final String title;
  final String subTitle;
  final String image;

  AudioPlayerData({
    required this.url,
    required this.duration,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  factory AudioPlayerData.init(
    final String url,
    final String duration,
    final String title,
    final String subTitle,
    final String image,
  ) {
    return AudioPlayerData(
      url: url,
      title: title,
      duration: duration,
      subTitle: subTitle,
      image: image,
    );
  }
}
