class PostDTO {
  final int id;
  final int userId;
  final String? userName;
  final String? profilePic;
  final String? imageUrl;
  final String? content;

  PostDTO({
    required this.id,
    required this.userId,
    this.userName,
    this.profilePic,
    this.imageUrl,
    this.content,
  });

  PostDTO.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        userId = json["user_id"],
        userName = json["user_name"],
        profilePic = json["profile_pic"],
        imageUrl = json["image"],
        content = json["content"];
}
