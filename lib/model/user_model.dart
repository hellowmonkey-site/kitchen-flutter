class UserModel {
  final int id;
  final String username;
  final String? password;
  final String cover;
  final String samp;
  final String nickname;
  final String token;
  final String createdAt;

  UserModel(
      {required this.id,
      required this.username,
      this.cover = '',
      required this.nickname,
      required this.samp,
      required this.token,
      required this.createdAt,
      this.password});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            username: json['username'],
            cover: json['cover'],
            nickname: json['nickname'],
            samp: json['samp'],
            token: json['token'],
            createdAt: json['created_at']);

  static postLogin() {}
}
