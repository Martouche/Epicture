class Picture {
  List<PictureList> pictureList;

  Picture({this.pictureList});

  factory Picture.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<PictureList> picturesList;
    if (list != null) {
      picturesList = list.map((i) => PictureList.fromJson(i)).toList();
    }
    return Picture(
      pictureList: picturesList
    );
  }
}

class PictureList {
  String id;
  List<Photo> photoList;

  PictureList({this.id, this.photoList});

  factory PictureList.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List;
    List<Photo> photosList;
    if (imageList != null) {
      photosList = imageList.map((i) => Photo.fromJson(i)).toList();
    }

    return PictureList(
      id: json['id'],
      photoList: photosList
    );
  }
}

class Photo {
  String link;
  String type;

  Photo({this.link, this.type,});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      link: json['link'],
      type: json['type'],
    );
  }
}

class Profile {
  final List<PhotoList> pictureList;

  Profile({this.pictureList});

  factory Profile.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<PhotoList> picturesList = list.map((i) => PhotoList.fromJson(i)).toList();
    return Profile(
        pictureList: picturesList
    );
  }
}

class PhotoList {
  String link;

  PhotoList({this.link,});

  factory PhotoList.fromJson(Map<String, dynamic> json) {
    return PhotoList(
      link: json['link'],
    );
  }
}