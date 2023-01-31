import 'package:hive/hive.dart';
import 'package:story_way/data/repository/local/story_database_repository.dart';

import '../../../common/constants/preferences_constants.dart';

class StoryDatabaseRepositoryHiveImpl implements StoryDatabaseRepository {
  final HiveInterface _hive = Hive;

  StoryDatabaseRepositoryHiveImpl();

  @override
  Future<void> addSeenStory({required String storyId}) async {
    final box = await _hive.openBox(PreferencesConstants.DATABASE_NAME);
    final seenStories = await box.get(
      PreferencesConstants.SEEN_STORIES,
      defaultValue: [],
    ) as List;
    final seenStoriesResolved = seenStories.map((e) => e.toString()).toList();
    if (!seenStoriesResolved.contains(storyId)) {
      seenStoriesResolved.add(storyId);
    }
    await box.put(PreferencesConstants.DATABASE_NAME, seenStoriesResolved);
  }

  @override
  Future<List<String>> getSeenStories() async {
    final box = await _hive.openBox(PreferencesConstants.DATABASE_NAME);
    final stories = await box.get(
      PreferencesConstants.SEEN_STORIES,
      defaultValue: [],
    ) as List;
    return stories.map((e) => e.toString()).toList();
  }

  @override
  Future<void> clear() async {
    final box = await _hive.openBox(PreferencesConstants.DATABASE_NAME);
    await box.deleteFromDisk();
  }
}
