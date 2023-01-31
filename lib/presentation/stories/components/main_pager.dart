import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_way/domain/models/user_story_model.dart';
import 'package:story_way/presentation/stories/components/story_pager.dart';
import 'package:story_way/presentation/stories/state/story_event_cubit.dart';
import 'package:story_way/presentation/stories/state/story_event_state.dart';

class MainPager extends StatefulWidget {
  final int selectedIndex;
  final List<UserStoryModel> stories;
  final Function(double changePercentage) positionChangeCallback;
  const MainPager({
    super.key,
    required this.selectedIndex,
    required this.stories,
    required this.positionChangeCallback,
  });

  @override
  State<MainPager> createState() => _MainPagerState();
}

class _MainPagerState extends State<MainPager> {
  int currentPageOnVertical = 0;
  late double currentOffsetValue;
  late int currentPage;
  late PageController pageController;
  late PageController verticalPageController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.selectedIndex;
    currentOffsetValue = widget.selectedIndex.toDouble();
    pageController = PageController(
      initialPage: currentPage,
    );
    verticalPageController = PageController(
      initialPage: currentPageOnVertical,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    verticalPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Listen for cubic transform
    pageController.addListener(() {
      currentOffsetValue = pageController.page ?? 0.0;
    });

    // Listen for swiping back or forward to exit
    bool isTapCancelled = false;
    pageController.addListener(() {
      if ((isTapCancelled && currentPage == 0 && pageController.offset < -50) ||
          (isTapCancelled &&
              currentPage == widget.stories.length - 1 &&
              pageController.offset - ((widget.stories.length - 1) * width) >
                  50)) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
      isTapCancelled = false;
    });

    // Listen for page background color on horizontal
    pageController.addListener(() {
      double lastSentValue = 0.0;
      if (currentPage == 0 && pageController.offset < 0) {
        lastSentValue = 1 - (pageController.offset / width).abs();
        widget.positionChangeCallback(lastSentValue);
      } else if (currentPage == widget.stories.length - 1 &&
          pageController.offset - ((widget.stories.length - 1) * width) > 0) {
        lastSentValue = 1 -
            ((pageController.offset - ((widget.stories.length - 1) * width)) /
                width);
        widget.positionChangeCallback(lastSentValue);
      } else {
        if (lastSentValue != 1.0) {
          widget.positionChangeCallback(1.0);
        }
      }
    });

    // Listen for swiping up or down to exit
    bool isVerticalTapCancelled = false;
    verticalPageController.addListener(() {
      if ((isVerticalTapCancelled &&
              currentPageOnVertical == 0 &&
              verticalPageController.offset < -5) ||
          (isVerticalTapCancelled && verticalPageController.offset > 5)) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
      isVerticalTapCancelled = false;
    });

    // Listen for page background color on vertical
    verticalPageController.addListener(() {
      double lastValue = 0.0;
      if (verticalPageController.offset < 0) {
        lastValue = 1 - (verticalPageController.offset / (height * 0.5)).abs();
        widget.positionChangeCallback(lastValue);
      } else if (verticalPageController.offset > 0) {
        lastValue = (height - verticalPageController.offset) / height;
        widget.positionChangeCallback(lastValue);
      } else {
        if (lastValue != 1.0) {
          widget.positionChangeCallback(1.0);
          lastValue = 1.0;
        }
      }
    });

    // Vertical Pager
    return BlocProvider<StoryEventCubit>(
      create: (context) => StoryEventCubit(),
      child: BlocListener<StoryEventCubit, StoryEventState>(
        child: Listener(
          onPointerUp: (event) {
            isTapCancelled = true;
            isVerticalTapCancelled = true;
          },
          child: Center(
            child: PageView.builder(
              controller: verticalPageController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Horizontal (User Based Stories) Pager
                  return PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    itemCount: widget.stories.length,
                    onPageChanged: (newIndex) {
                      currentPage = newIndex;
                    },
                    itemBuilder: (context, index) {
                      final model = widget.stories[index];
                      final k = currentOffsetValue - index;
                      if (index == currentOffsetValue.floor()) {
                        return Transform(
                          alignment: FractionalOffset.centerRight,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.003)
                            ..rotateY((pi / 2) * (k * 0.75)),
                          child: StoryPager(
                            stories: model.stories,
                            profilePic: model.profilePic ?? "",
                            userName: model.userName ?? "",
                            userId: model.userId,
                          ),
                        );
                      } else if (index == currentOffsetValue.floor() + 1) {
                        return Transform(
                          alignment: FractionalOffset.centerLeft,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.003)
                            ..rotateY((pi / 2) * (k * 0.75)),
                          child: StoryPager(
                            stories: model.stories,
                            profilePic: model.profilePic ?? "",
                            userName: model.userName ?? "",
                            userId: model.userId,
                          ),
                        );
                      } else {
                        return StoryPager(
                          stories: model.stories,
                          profilePic: model.profilePic ?? "",
                          userName: model.userName ?? "",
                          userId: model.userId,
                        );
                      }
                    },
                  );
                } else {
                  return Container(
                    color: Colors.transparent,
                  );
                }
              },
            ),
          ),
        ),
        listener: (context, state) {
          if (state.event == StoryEvent.GO_NEXT_USER) {
            if (currentPage + 1 != widget.stories.length) {
              currentPage++;
              pageController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
              );
              BlocProvider.of<StoryEventCubit>(context)
                  .fire(event: StoryEvent.RESUMED);
            } else {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            }
          }
          if (state.event == StoryEvent.GO_PREVIOUS_USER) {
            if (currentPage - 1 >= 0) {
              currentPage--;
              pageController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
              );
              BlocProvider.of<StoryEventCubit>(context)
                  .fire(event: StoryEvent.RESUMED);
            } else {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            }
          }
        },
      ),
    );
  }
}
