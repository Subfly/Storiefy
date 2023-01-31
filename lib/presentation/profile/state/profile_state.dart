import 'package:equatable/equatable.dart';
import 'package:story_way/domain/models/post_model.dart';
import 'package:story_way/domain/models/user_model.dart';
import 'package:story_way/domain/models/user_story_model.dart';

class ProfileState extends Equatable {
  final UserModel? user;
  final UserStoryModel? stories;
  final List<PostModel> posts;
  final bool isLoading;
  final String errorMessage;

  const ProfileState({
    required this.user,
    required this.stories,
    required this.posts,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [user, isLoading, errorMessage];

  ProfileState copy({
    UserModel? user,
    UserStoryModel? stories,
    List<PostModel>? posts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
