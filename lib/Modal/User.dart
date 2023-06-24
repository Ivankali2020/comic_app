class User {
  User({
    required this.id,
    required this.name,
    required this.photo,
    required this.credentials,
  });
  late final int id;
  late final String name;
  late final String photo;
  late final String credentials;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    credentials = json['credentials'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['photo'] = photo;
    _data['credentials'] = credentials;
    return _data;
  }
}