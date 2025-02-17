class EventModel {
  String name;
  String notes;
  DateTime date;
  String location;
  String id;
  DateTime createdDate;
  List<dynamic> images;
  List<dynamic> videos;
  List<dynamic> audios;

  EventModel({
    required this.name,
    required this.notes,
    required this.date,
    required this.location,
    required this.id,
    required this.createdDate,
    required this.images,
    required this.videos,
    required this.audios,
  });

  EventModel copyWith({
    String? name,
    String? notes,
    DateTime? date,
    String? location,
    String? id,
    DateTime? createdDate,
    List<dynamic>? images,
    List<dynamic>? videos,
    List<dynamic>? audios,
  }) =>
      EventModel(
        name: name ?? this.name,
        notes: notes ?? this.notes,
        date: date ?? this.date,
        location: location ?? this.location,
        id: id ?? this.id,
        createdDate: createdDate ?? this.createdDate,
        images: images ?? this.images,
        videos: videos ?? this.videos,
        audios: audios ?? this.audios,
      );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    name: json["name"],
    notes: json["notes"],
    date: json["date"],
    location: json["location"],
    id: json["id"],
    createdDate: json["createdDate"],
    images: List<dynamic>.from(json["images"].map((x) => x)),
    videos: List<dynamic>.from(json["videos"].map((x) => x)),
    audios: List<dynamic>.from(json["audios"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "notes": notes,
    "date": date,
    "location": location,
    "id": id,
    "createdDate": createdDate,
    "images": List<dynamic>.from(images.map((x) => x)),
    "videos": List<dynamic>.from(videos.map((x) => x)),
    "audios": List<dynamic>.from(audios.map((x) => x)),
  };
}
