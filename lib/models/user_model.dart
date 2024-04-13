class UserModel {
  UserModel({
    this.userId,
    this.image,
    this.name,
    this.emailAddress,
    this.password,
    this.likedMusic,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"];
    image = json["image"];
    name = json["name"];
    emailAddress = json["email_address"];
    password = json["password"];
    likedMusic = (json["liked_music"] as List<dynamic>).cast<String>();
  }

  String? userId;
  String? image;
  String? name;
  String? emailAddress;
  String? password;
  List<String>? likedMusic;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["user_id"] = userId;
    data["image"] = image;
    data["name"] = name;
    data["email_address"] = emailAddress;
    data["password"] = password;
    data["liked_music"] = likedMusic;
    return data;
  }
}
