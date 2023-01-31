import 'package:story_way/data/dto/post_dto.dart';

class PostModel {
  final int id;
  final int userId;
  final String? userName;
  final String? profilePic;
  final String? imageUrl;
  final String? content;

  PostModel({
    required this.id,
    required this.userId,
    this.userName,
    this.profilePic,
    this.imageUrl,
    this.content,
  });

  PostModel.fromDTO({required PostDTO dto})
    : id = dto.id,
      userId = dto.userId,
      userName = dto.userName,
      profilePic = dto.profilePic,
      imageUrl = dto.imageUrl,
      content = dto.content;
}