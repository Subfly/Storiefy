import 'package:story_way/data/dao/posts_dao.dart';
import 'package:story_way/data/dto/post_dto.dart';
import 'package:story_way/data/service/app_database_service.dart';

class PostRepository implements PostDAO {
  final AppDatabaseService service;

  PostRepository({required this.service});

  @override
  Future<PostDTO?> getPostById({required int postId}) {
    return service.fetchPostById(id: postId);
  }

  @override
  Future<List<PostDTO>> getPosts() {
    return service.fetchPosts();
  }
  
  @override
  Future<List<PostDTO>> getPostsOfUser({required int userId}) {
    return service.fetchPostsByUserId(userId: userId);
  }
}