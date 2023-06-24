
class Comic{
  Comic({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.review,
    required this.cover,
    required this.createdAt,
    required this.episodes,
  });
  late final int id;
  late final int authorId;
  late final String authorName;
  late final int categoryId;
  late final String categoryName;
  late final String name;
  late final String review;
  late final String cover;
  late final String createdAt;
  late final List<Episodes> episodes;

  Comic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authorId = json['author_id'];
    authorName = json['author_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    name = json['name'];
    review = json['review'];
    cover = json['cover'];
    createdAt = json['created_at'];
    episodes =
        List.from(json['episodes']).map((e) => Episodes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['author_id'] = authorId;
    _data['author_name'] = authorName;
    _data['category_id'] = categoryId;
    _data['category_name'] = categoryName;
    _data['name'] = name;
    _data['review'] = review;
    _data['cover'] = cover;
    _data['created_at'] = createdAt;
    _data['episodes'] = episodes.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Episodes {
  Episodes({
    required this.id,
    required this.title,
    required this.episode,
    required this.episodeTitle,
    required this.photos,
    required this.isRead,
  });
  late final int id;
  late final String title;
  late final String episode;
  late final String episodeTitle;
  late final List<String> photos;
  late bool isRead;

  void readDone() {
    isRead = true;
  }

  Episodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    episode = json['episode'];
    episodeTitle = json['episode_title'];
    photos = List.castFrom<dynamic, String>(json['photos']);
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['episode'] = episode;
    _data['episode_title'] = episodeTitle;
    _data['photos'] = photos;
    _data['is_read'] = isRead;
    return _data;
  }
}
