abstract class StoryDatabaseRepository {
  Future<void> addSeenStory({required String storyId});
  Future<List<String>> getSeenStories();
  Future<void> clear();
}