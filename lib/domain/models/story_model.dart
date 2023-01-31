import 'dart:io';

import 'package:story_way/data/dto/story_dto.dart';

import '../../common/enums/content_type.dart';

class StoryModel {
  final String id;
  final ContentType? type;
  final String? url;
  final bool isSeen;

  StoryModel({
    required this.id,
    this.type,
    this.url,
    this.isSeen = false,
  });

  StoryModel.fromDTO({required StoryDTO dto})
      : id = dto.id,
        type = dto.type,
        url = dto.url,
        isSeen = false;

  StoryModel copy({
    String? id,
    ContentType? type,
    String? url,
    bool? isSeen,
  }) {
    return StoryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      url: url ?? this.url,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}
