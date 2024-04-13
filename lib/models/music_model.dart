class MusicModel {
  MusicModel({this.image, this.name, this.by, this.link});

  MusicModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    name = json["name"];
    by = json["by"];
    link = json["link"];
  }

  String? image;
  String? name;
  String? by;
  String? link;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["image"] = image;
    data["name"] = name;
    data["by"] = by;
    data["link"] = link;
    return data;
  }
}
