import 'package:story_way/data/dto/story_dto.dart';
import 'package:story_way/data/dto/user_story_dto.dart';

abstract class StoriesDAO {
  Future<List<UserStoryDTO>> getStories();
  Future<UserStoryDTO?> getStoriesById({required int storiesId});
  Future<UserStoryDTO?> getStoriesOfUser({required int userId});
  Future<StoryDTO?> getStoryByStoryId({required int storiesId, required String storyId});
  Future<StoryDTO?> getStoryOfUser({required int userId, required String storyId});
}