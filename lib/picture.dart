class Picture {
  final List<PictureList> pictureList;

  Picture({this.pictureList});

  factory Picture.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<PictureList> picturesList = list.map((i) => PictureList.fromJson(i)).toList();
    return Picture(
      pictureList: picturesList
    );
  }
}

class PictureList {
  final String link;

  PictureList({this.link});

  factory PictureList.fromJson(Map<String, dynamic> json) {
    return PictureList(
      link: json['link']
    );
  }
}