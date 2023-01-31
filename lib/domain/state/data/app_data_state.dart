import 'package:equatable/equatable.dart';
import 'package:story_way/domain/models/post_model.dart';
import 'package:story_way/domain/models/user_model.dart';
import 'package:story_way/domain/models/user_story_model.dart';

class AppDataState extends Equatable {
  final List<UserStoryModel> stories;
  final List<PostModel> posts;
  final UserModel? currentUser;
  final bool isLoading;
  final String errorMessage;

  const AppDataState({
    required this.currentUser,
    required this.posts,
    required this.stories,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [currentUser, posts, stories];

  AppDataState copy({
    List<UserStoryModel>? stories,
    List<PostModel>? posts,
    UserModel? currentUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppDataState(
      currentUser: currentUser ?? this.currentUser,
      posts: posts ?? this.posts,
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
