import 'package:bloc/bloc.dart';
import 'package:story_way/data/repository/local/story_database_repository.dart';
import 'package:story_way/data/service/app_database_service.dart';
import 'package:story_way/domain/repository/remote/post_repository_impl.dart';
import 'package:story_way/domain/repository/remote/story_repository_impl.dart';
import 'package:story_way/domain/repository/remote/user_repository_impl.dart';
import 'package:story_way/domain/state/data/app_data_state.dart';

class AppDataCubit extends Cubit<AppDataState> {
  /// Notes from developer:
  /// - Yeah, there is nothing to say for it,
  /// - I can also implement a authentication mechanism
  /// - However, I would greatly increase the development
  /// time in the end. So, let's continue with the constant value...
  final _CURRENT_USER_ID = 0;
  late AppDatabaseService _service;
  late UserRepositoryImpl _userRepository;
  late PostRepositoryImpl _postRepository;
  late StoryRepositoryImpl _storyRepository;
  late StoryDatabaseRepository _databaseRepository;

  AppDataCubit(this._databaseRepository)
      : super(
          const AppDataState(
            currentUser: null,
            posts: [],
            stories: [],
            isLoading: true,
            errorMessage: "",
          ),
        );

  Future<void> init() async {
    // Init variables
    _service = AppDatabaseService();
    _userRepository = UserRepositoryImpl(_service);
    _postRepository = PostRepositoryImpl(_service);
    _storyRepository = StoryRepositoryImpl(_service);

    // Get State Data
    final userData =
        await _userRepository.getUserById(userId: _CURRENT_USER_ID);
    final seenStories = await _databaseRepository.getSeenStories();
    final stories = await _storyRepository.getStories();
    final posts = await _postRepository.getPosts();

    // Prepare State
    final preparedStories = stories.map(
      (user) {
        return user.copy(
          stories: user.stories.map(
            (story) {
              if (seenStories.contains(story.id)) {
                return story.copy(isSeen: true);
              } else {
                return story;
              }
            },
          ).toList(),
        );
      },
    ).toList();

    emit(
      state.copy(
        currentUser: userData,
        stories: preparedStories,
        posts: posts,
        isLoading: false,
        errorMessage: "",
      ),
    );
  }

  void addSeenStory({required String storyId, required int userId}) async {
    // GET INDEXES
    final currentStories = state.stories;
    final userIndex =
        currentStories.indexWhere((element) => element.userId == userId);
    final storyIndex = currentStories[userIndex]
        .stories
        .indexWhere((element) => element.id == storyId);

    // SAVE TO LOCAL
    await _databaseRepository.addSeenStory(storyId: storyId);

    // SAVE TO STATE
    final story = currentStories[userIndex].stories[storyIndex];
    if (!story.isSeen) {
      currentStories[userIndex].stories[storyIndex] = story.copy(isSeen: true);
      // EMIT STATE
      emit(
        state.copy(
          stories: currentStories,
        ),
      );
    }
  }
}
