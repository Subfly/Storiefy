import 'package:story_way/data/dao/stories_dao.dart';
import 'package:story_way/data/dto/user_story_dto.dart';
import 'package:story_way/data/dto/story_dto.dart';

import '../../service/app_database_service.dart';


class StoryRepository implements StoriesDAO {
  final AppDatabaseService service;

  StoryRepository({required this.service});

  @override
  Future<List<UserStoryDTO>> getStories() {
    return service.fetchStories();
  }

  @override
  Future<UserStoryDTO?> getStoriesById({required int storiesId}) {
    return service.fetchUserStoryById(id: storiesId);
  }

  @override
  Future<UserStoryDTO?> getStoriesOfUser({required int userId}) {
    return service.fetchStoriesOfUser(id: userId);
  }

  @override
  Future<StoryDTO?> getStoryByStoryId({required int storiesId, required String storyId}) {
    return service.fetchStoryByStoryId(storiesId: storiesId, storyId: storyId);
  }

  @override
  Future<StoryDTO?> getStoryOfUser({required int userId, required String storyId}) {
    return service.fetchStoryOfUser(userId: userId, storyId: storyId);
  }
}
