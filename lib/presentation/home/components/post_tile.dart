import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_way/domain/models/post_model.dart';
import 'package:story_way/presentation/home/components/profile_image.dart';
import 'package:story_way/presentation/profile/profile_view.dart';

class PostTile extends StatelessWidget {
  final PostModel model;

  const PostTile({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProfileView.route,
              arguments: ProfileViewArguments(
                userId: model.userId,
                userName: model.userName ?? "",
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Row(
                  children: [
                    ProfileImage(
                      imageUrl: model.profilePic ?? "",
                      backgroundSize: width / 10,
                      foregroundSize: width / 23,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text(model.userName ?? ""),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Entypo.dots_three_horizontal),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Image.network(
          model.imageUrl ?? "",
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height * 0.3,
              alignment: Alignment.center,
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: 36,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height * 0.3,
              alignment: Alignment.center,
              child: const Text(
                "Error loading image, please try again later...",
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Feather.heart),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(SimpleLineIcons.bubbles),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Feather.send),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: RichText(
            text: TextSpan(
              text: model.userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              children: [
                TextSpan(
                  text: " ${model.content}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
