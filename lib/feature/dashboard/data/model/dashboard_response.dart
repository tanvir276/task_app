// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) =>
    DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) =>
    json.encode(data.toJson());

class DashboardResponse {
  DashboardResponse({
    this.success,
    this.data,
  });

  bool? success;
  List<Videos>? data;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      DashboardResponse(
        success: json["success"],
        data: List<Videos>.from(json["data"].map((x) => Videos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Videos {
  Videos({
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.createdAt,
  });

  int id;
  String caption;
  String videoUrl;
  DateTime createdAt;

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        id: json["id"],
        caption: json["caption"],
        videoUrl: json["video_url"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caption": caption,
        "video_url": videoUrl,
        "created_at": createdAt.toIso8601String(),
      };
}
