class UserDTO {
  final int id;
  final String? userName;
  final String? profilePic;
  final List<int> postIds;
  final List<int> storyIds;

  UserDTO({
    required this.id,
    this.userName,
    this.profilePic,
    this.postIds = const [],
    this.storyIds = const [],
  });

  UserDTO.fromJson(Map<String, dynamic> json)
      : id = json["user_id"],
        userName = json["user_name"],
        profilePic = json["profile_pic"],
        postIds = List<int>.from(json["posts"]),
        storyIds = List<int>.from(json["stories"]);
}
