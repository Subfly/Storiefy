import 'package:story_way/data/dto/user_story_dto.dart';
import 'package:story_way/domain/models/story_model.dart';

class UserStoryModel {
  final int id;
  final int userId;
  final String? userName;
  final String? profilePic;
  final List<StoryModel> stories;

  UserStoryModel({
    required this.id,
    required this.userId,
    this.userName,
    this.profilePic,
    this.stories = const [],
  });

  UserStoryModel.fromDTO({required UserStoryDTO dto})
      : id = dto.id,
        userId = dto.userId,
        userName = dto.userName,
        profilePic = dto.profilePic,
        stories = dto.stories.map((e) => StoryModel.fromDTO(dto: e)).toList();

  UserStoryModel copy({
    String? userName,
    String? profilePic,
    List<StoryModel>? stories,
  }) {
    return UserStoryModel(
      id: id,
      userId: userId,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
      stories: stories ?? this.stories,
    );
  }
}
