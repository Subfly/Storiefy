import 'package:flutter/material.dart';
import 'package:story_way/common/constants/hero_tags.dart';
import 'package:story_way/presentation/home/components/profile_image.dart';

class StoryButton extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String userName;
  final Function() onPressed;

  const StoryButton({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.userName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Hero(
            tag: "${HeroTags.STORY_TAG}$id",
            child: ProfileImage(
              imageUrl: imageUrl,
              backgroundSize: width / 5.8,
              foregroundSize: width / 12.8,
            ),
          ),
          Text(userName.isEmpty ? "-" : userName),
        ],
      ),
    );
  }
}
