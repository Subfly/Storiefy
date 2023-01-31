import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:story_way/data/dao/posts_dao.dart';
import 'package:story_way/data/dto/post_dto.dart';
import 'package:story_way/data/dto/story_dto.dart';
import 'package:story_way/data/dto/user_dto.dart';
import 'package:story_way/data/dto/user_story_dto.dart';

/// Notes from developer,
/// - Normally I won't do something like this.
/// - However, there were no API requests required for this task (as given in requirements file)
/// - Hence, I created this service to simulate an API call like behavior, because why not :d
/// - This is why I read the json file and make seconds of delays on functions.
///TODO: ADD LOGGING INTERCEPTOR

class AppDatabaseService {
  static final AppDatabaseService _instance = AppDatabaseService._internal();

  factory AppDatabaseService() {
    return _instance;
  }

  AppDatabaseService._internal() {}

  Future<List<UserDTO>> fetchUsersData() async {
    try {
      final appData = await rootBundle.loadString("./assets/app_data.json");
      final response = jsonDecode(appData);
      final users = response["users"] as List<dynamic>;

      return users.map((e) => UserDTO.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_USERS_DATA:\n$e");
      }
      return [];
    }
  }

  Future<UserDTO?> fetchUserDataById({required int id}) async {
    try {
      final users = await fetchUsersData();
      await Future.delayed(const Duration(milliseconds: 512));
      return users.firstWhere((element) => element.id == id);
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_USER_DATA:\n$e");
      }
      return null;
    }
  }

  Future<List<PostDTO>> fetchPosts() async {
    try {
      final appData = await rootBundle.loadString("./assets/app_data.json");
      final response = jsonDecode(appData);
      final posts = response["posts"] as List<dynamic>;

      return posts.map((e) => PostDTO.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_POSTS_DATA:\n$e");
      }
      return [];
    }
  }


  Future<List<PostDTO>> fetchPostsByUserId({required int userId}) async {
    try {
      final posts = await fetchPosts();
      return posts.where((element) => element.userId == userId).toList();
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_POST_DATA_USER:\n$e");
      }
      return [];
    }
  }

  Future<PostDTO?> fetchPostById({required int id}) async {
    try {
      final posts = await fetchPosts();
      await Future.delayed(const Duration(milliseconds: 512));

      return posts.firstWhere((element) => element.id == id);
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_POST_DATA:\n$e");
      }
      return null;
    }
  }

  Future<List<UserStoryDTO>> fetchStories() async {
    try {
      final appData = await rootBundle.loadString("./assets/app_data.json");
      final response = jsonDecode(appData);
      final stories = response["stories"] as List<dynamic>;

      return stories.map((e) => UserStoryDTO.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_ALL_STORIES_DATA:\n$e");
      }
      return [];
    }
  }

  Future<UserStoryDTO?> fetchUserStoryById({required int id}) async {
    try {
      final userStories = await fetchStories();
      return userStories.firstWhere((element) => element.id == id);
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_ALL_STORY_DATA:\n$e");
      }
      return null;
    }
  }

  Future<UserStoryDTO?> fetchStoriesOfUser({required int id}) async {
    try {
      final userStories = await fetchStories();
      return userStories.firstWhere((element) => element.userId == id);
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_USER_STORIES_DATA:\n$e");
      }
      return null;
    }
  }

  Future<StoryDTO?> fetchStoryByStoryId({
    required int storiesId,
    required String storyId,
  }) async {
    try {
      final superStories = await fetchUserStoryById(id: storiesId);
      return superStories?.stories
          .firstWhere((element) => element.id == storyId);
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_USER_STORY_DATA_BY_ID:\n$e");
      }
      return null;
    }
  }

  Future<StoryDTO?> fetchStoryOfUser({
    required int userId,
    required String storyId,
  }) async {
    try {
      final superStories = await fetchStoriesOfUser(id: userId);
      return superStories?.stories
          .firstWhere((element) => element.id == storyId);
    } catch (e) {
      if (kDebugMode) {
        print("FETCH_USER_STORY_DATA_BY_USER:\n$e");
      }
      return null;
    }
  }
}
