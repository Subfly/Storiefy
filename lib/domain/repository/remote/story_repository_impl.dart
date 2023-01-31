import 'package:story_way/data/dto/user_story_dto.dart';
import 'package:story_way/data/service/app_database_service.dart';
import 'package:story_way/domain/models/story_model.dart';
import 'package:story_way/domain/models/user_story_model.dart';

import '../../../data/repository/remote/story_repository.dart';

class StoryRepositoryImpl {
  late StoryRepository _repo;

  StoryRepositoryImpl(AppDatabaseService service) {
    _repo = StoryRepository(service: service);
  }

  Future<List<UserStoryModel>> getStories() async {
    final storiesDto = await _repo.getStories();
    return storiesDto.map((e) => UserStoryModel.fromDTO(dto: e)).toList();
  }

  Future<UserStoryModel?> getStoriesById({required int storiesId}) async {
    final storiesDto = await _repo.getStoriesById(storiesId: storiesId);
    if(storiesDto == null) {
      return null;
    }
    return UserStoryModel.fromDTO(dto: storiesDto);
  }

  Future<UserStoryModel?> getStoriesOfUser({required int userId}) async {
    final storiesDto = await _repo.getStoriesOfUser(userId: userId);
    if (storiesDto == null) {
      return null;
    }
    return UserStoryModel.fromDTO(dto: storiesDto);
  }

  Future<StoryModel?> getStoryByStoryId({required int storiesId, required String storyId}) async {
    final storyDto = await _repo.getStoryByStoryId(storiesId: storiesId, storyId: storyId);
    if(storyDto == null) {
      return null;
    }
    return StoryModel.fromDTO(dto: storyDto);
  }

  Future<StoryModel?> getStoryOfUser({required int userId, required String storyId}) async {
    final storyDto = await _repo.getStoryOfUser(userId: userId, storyId: storyId);
    if(storyDto == null) {
      return null;
    }
    return StoryModel.fromDTO(dto: storyDto);
  }
}