import 'package:bloc/bloc.dart';
import 'package:story_way/data/service/app_database_service.dart';
import 'package:story_way/domain/repository/remote/post_repository_impl.dart';
import 'package:story_way/domain/repository/remote/story_repository_impl.dart';
import 'package:story_way/presentation/profile/state/profile_state.dart';

import '../../../domain/repository/remote/user_repository_impl.dart';

class ProfileCubit extends Cubit<ProfileState> {
  late AppDatabaseService _service;
  late UserRepositoryImpl _userRepository;
  late PostRepositoryImpl _postRepository;
  late StoryRepositoryImpl _storyRepository;

  ProfileCubit()
      : super(
          const ProfileState(
            user: null,
            stories: null,
            posts: [],
            isLoading: true,
            errorMessage: "",
          ),
        );

  Future<void> init({required int userId}) async {
    _service = AppDatabaseService();
    _userRepository = UserRepositoryImpl(_service);
    _postRepository = PostRepositoryImpl(_service);
    _storyRepository = StoryRepositoryImpl(_service);

    final user = await _userRepository.getUserById(userId: userId);
    if(user == null) {
      emit(state.copy(
        user: null,
        isLoading: false,
        errorMessage: "An unknown error occurred, please try again later...",
      ));
      return;
    }

    final stories = await _storyRepository.getStoriesOfUser(userId: user.id);
    final posts = await _postRepository.getPostsOfUser(userId: userId);

    emit(state.copy(
      user: user,
      stories: stories,
      posts: posts,
      isLoading: false,
      errorMessage: "",
    ));
  }
}
