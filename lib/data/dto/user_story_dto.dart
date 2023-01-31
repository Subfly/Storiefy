import 'package:story_way/data/dto/story_dto.dart';

class UserStoryDTO {
  final int id;
  final int userId;
  final String? userName;
  final String? profilePic;
  final List<StoryDTO> stories;

  UserStoryDTO({
    required this.id,
    required this.userId,
    this.userName,
    this.profilePic,
    this.stories = const [],
  });

  UserStoryDTO.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        userId = json["user_id"],
        userName = json["user_name"],
        profilePic = json["profile_pic"],
        stories = List<dynamic>.from(
          json["items"],
        )
            .map(
              (e) => StoryDTO.fromJson(e),
            )
            .toList();
}
