import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

const experienceCategories = {
  'internship': 'Internship',
  'research': 'Research',
  'volunteer': 'Volunteer',
  'part-time': 'Part-Time',
  'full-time': 'Full-Time',
  'freelance': 'Freelance',
};

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.startedAt,
    this.category = 'full-time',
    this.endedAt,
    this.thumbnail,
    this.starCount = 0,
  });

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String organization;
  final String description;
  final String category;
  final String startedAt;
  final String? endedAt;
  final String? thumbnail;

  @JsonKey(includeToJson: false)
  final int starCount;

  String get categoryLabel => experienceCategories[category] ?? category;

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
