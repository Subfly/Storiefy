import '../../common/enums/content_type.dart';

class StoryDTO {
  final String id;
  final ContentType? type;
  final String? url;

  StoryDTO({
    required this.id,
    this.type,
    this.url,
  });

  StoryDTO.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        type = json["type"] == 1 ? ContentType.VIDEO : ContentType.IMAGE,
        url = json["url"];
}
