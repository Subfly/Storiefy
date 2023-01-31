import 'package:flutter/widgets.dart';
import 'package:story_way/domain/models/user_story_model.dart';
import 'package:story_way/presentation/home/components/story_button.dart';

import '../../stories/story_view.dart';

class StoriesRow extends StatelessWidget {
  final List<UserStoryModel> stories;
  final Function(int index) onStoryPressed;

  const StoriesRow({
    super.key,
    required this.stories,
    required this.onStoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 4,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: true,
        itemCount: stories.length,
        itemBuilder: (_, index) {
          final model = stories[index];
          if (index == 0) {
            return Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                StoryButton(
                  id: model.id,
                  imageUrl: model.profilePic ?? "",
                  userName: model.userName ?? "",
                  onPressed: () {
                    onStoryPressed(index);
                  },
                )
              ],
            );
          } else if (index == stories.length - 1) {
            return Row(
              children: [
                StoryButton(
                  id: model.id,
                  imageUrl: model.profilePic ?? "",
                  userName: model.userName ?? "",
                  onPressed: () {
                    onStoryPressed(index);
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            );
          } else {
            return StoryButton(
              id: model.id,
              imageUrl: model.profilePic ?? "",
              userName: model.userName ?? "",
              onPressed: () {
                onStoryPressed(index);
              },
            );
          }
        },
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 15,
          );
        },
      ),
    );
  }
}
