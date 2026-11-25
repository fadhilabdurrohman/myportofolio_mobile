import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.description,
    required this.year,
    required this.projectType,
    this.url,
    this.thumbnail,
    this.starCount = 0,
  });

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;
  final int year;
  final String projectType;
  final String? url;
  final String? thumbnail;

  @JsonKey(includeToJson: false)
  final int starCount;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
