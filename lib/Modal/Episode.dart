class Episode {
  Episode({
    required this.id,
    required this.title,
    required this.episode,
    required this.episodeTitle,
    required this.photos,
  });
  late final int id;
  late final String title;
  late final String episode;
  late final String episodeTitle;
  late final List<String> photos;

  Episode.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    episode = json['episode'];
    episodeTitle = json['episode_title'];
    photos = List.castFrom<dynamic, String>(json['photos']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['episode'] = episode;
    _data['episode_title'] = episodeTitle;
    _data['photos'] = photos;
    return _data;
  }
}