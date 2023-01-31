import 'package:story_way/data/dto/post_dto.dart';

abstract class PostDAO {
  Future<List<PostDTO>> getPosts();
  Future<PostDTO?> getPostById({required int postId});
  Future<List<PostDTO>> getPostsOfUser({required int userId});
}