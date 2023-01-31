import 'package:story_way/data/dto/user_dto.dart';

class UserModel {
  final int id;
  final String? userName;
  final String? profilePic;
  final List<int> postIds;
  final List<int> storyIds;

  UserModel({
    required this.id,
    this.userName,
    this.profilePic,
    this.postIds = const [],
    this.storyIds = const [],
  });

  UserModel.fromDTO({required UserDTO dto})
    : id = dto.id,
      userName = dto.userName,
      profilePic = dto.profilePic,
      postIds = dto.postIds,
      storyIds = dto.storyIds;
}