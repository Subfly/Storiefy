import 'package:story_way/data/service/app_database_service.dart';

import 'package:story_way/domain/models/post_model.dart';

import '../../../data/repository/remote/post_repository.dart';

class PostRepositoryImpl {
  late PostRepository _repo;

  PostRepositoryImpl(AppDatabaseService service) {
    _repo = PostRepository(service: service);
  }

  Future<List<PostModel>> getPosts() async {
    final posts = await _repo.getPosts();
    return posts.map((e) => PostModel.fromDTO(dto: e)).toList();
  }

  Future<PostModel?> getPostById({required int postId}) async {
    final postDto = await _repo.getPostById(postId: postId);
    if (postDto == null) {
      return null;
    }
    return PostModel.fromDTO(dto: postDto);
  }

  Future<List<PostModel>> getPostsOfUser({required int userId}) async {
    final posts = await _repo.getPostsOfUser(userId: userId);
    return posts.map((e) => PostModel.fromDTO(dto: e)).toList();
  }
}
