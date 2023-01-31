import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:story_way/domain/models/story_model.dart';
import 'package:story_way/presentation/home/components/profile_image.dart';
import 'package:story_way/presentation/stories/components/image_story_component.dart';
import 'package:story_way/presentation/stories/components/video_story_component.dart';
import 'package:story_way/presentation/stories/state/story_event_cubit.dart';
import 'package:story_way/presentation/stories/state/story_event_state.dart';
import '../../../common/enums/content_type.dart';

class StoryPager extends StatefulWidget {
  final List<StoryModel> stories;
  final String profilePic;
  final String userName;
  final int userId;
  const StoryPager({
    super.key,
    required this.stories,
    required this.profilePic,
    required this.userName,
    required this.userId,
  });

  @override
  State<StoryPager> createState() => _StoryPagerState();
}

class _StoryPagerState extends State<StoryPager> {
  List<double> completions = [];
  late int currentPage;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    final lastSeenIndex =
        widget.stories.indexWhere((element) => element.isSeen == false);
    currentPage =
        lastSeenIndex == -1 ? widget.stories.length - 1 : lastSeenIndex;
    pageController = PageController(
      initialPage: currentPage,
    );
    for (final element in widget.stories) {
      completions.add(element.isSeen ? 1 : 0);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryEventCubit, StoryEventState>(
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.stories.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final story = widget.stories[index];
                  if (story.type == ContentType.IMAGE) {
                    return ImageStoryComponent(
                      storyId: story.id,
                      userId: widget.userId,
                      imgUrl: story.url ?? "",
                      onTickCallback: (completion) {
                        setState(() {
                          completions[index] = completion;
                        });
                      },
                      onEndCallback: () {
                        BlocProvider.of<StoryEventCubit>(context)
                            .fire(event: StoryEvent.GO_NEXT_STORY);
                      },
                    );
                  } else {
                    return VideoStoryComponent(
                      storyId: story.id,
                      userId: widget.userId,
                      videoUrl: story.url ?? "",
                      onTickCallback: (completion) {
                        setState(() {
                          completions[index] = completion;
                        });
                      },
                      onEndCallback: () {
                        BlocProvider.of<StoryEventCubit>(context)
                            .fire(event: StoryEvent.GO_NEXT_STORY);
                      },
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Row(
                    children: completions
                        .map(
                          (e) => Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                height: 5,
                                child: LinearProgressIndicator(
                                  value: e,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Colors.white70,
                                  ),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                        ),
                        child: Row(
                          children: [
                            ProfileImage(
                              imageUrl: widget.profilePic,
                              backgroundSize: 20,
                              foregroundSize: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          right: 20,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Ionicons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      listener: (context, state) {
        if (state.event == StoryEvent.GO_PREVIOUS_STORY) {
          if (currentPage - 1 >= 0) {
            currentPage--;
            pageController.jumpToPage(currentPage);
            BlocProvider.of<StoryEventCubit>(context)
                .fire(event: StoryEvent.RESUMED);
          } else {
            BlocProvider.of<StoryEventCubit>(context)
                .fire(event: StoryEvent.GO_PREVIOUS_USER);
          }
        }

        if (state.event == StoryEvent.GO_NEXT_STORY) {
          if (currentPage + 1 != widget.stories.length) {
            currentPage++;
            pageController.jumpToPage(currentPage);
            BlocProvider.of<StoryEventCubit>(context)
                .fire(event: StoryEvent.RESUMED);
          } else {
            BlocProvider.of<StoryEventCubit>(context)
                .fire(event: StoryEvent.GO_NEXT_USER);
          }
        }
      },
    );
  }
}
