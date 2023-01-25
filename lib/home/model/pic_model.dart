class PicModel {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  PicModel(
      {required this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  factory PicModel.fromJson(Map<String, dynamic> json) => PicModel(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
      );
}
