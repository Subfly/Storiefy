import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_way/domain/state/data/app_data_cubit.dart';
import 'package:story_way/presentation/stories/state/story_event_cubit.dart';
import 'package:story_way/presentation/stories/state/story_event_state.dart';

class ImageStoryComponent extends StatefulWidget {
  final String storyId;
  final int userId;
  final String imgUrl;
  final Function(double completion) onTickCallback;
  final Function onEndCallback;
  const ImageStoryComponent({
    super.key,
    required this.storyId,
    required this.userId,
    required this.imgUrl,
    required this.onTickCallback,
    required this.onEndCallback,
  });

  @override
  State<ImageStoryComponent> createState() => _ImageStoryComponentState();
}

class _ImageStoryComponentState extends State<ImageStoryComponent> {
  final timeToCompare = const Duration(seconds: 5);
  Duration timerLength = const Duration(seconds: 5);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 5),
      (timer) {
        if (mounted) {
          if (timerLength.inMilliseconds > 0) {
            timerLength -= const Duration(milliseconds: 5);
            final elapsed = timeToCompare - timerLength;
            widget.onTickCallback(
              elapsed.inMilliseconds / timeToCompare.inMilliseconds,
            );
            if(elapsed > const Duration(milliseconds:  1500)) {
              BlocProvider.of<AppDataCubit>(context).addSeenStory(
                storyId: widget.storyId,
                userId: widget.userId,
              );
            }
          } else {
            timer.cancel();
            widget.onTickCallback(1);
            BlocProvider.of<AppDataCubit>(context).addSeenStory(
              storyId: widget.storyId,
              userId: widget.userId,
            );
            widget.onEndCallback();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTapUp: (details) {
        final position = details.globalPosition.dx;
        if (position < width * 0.3) {
          widget.onTickCallback(0);
          timer.cancel();
          BlocProvider.of<AppDataCubit>(context).addSeenStory(
            storyId: widget.storyId,
            userId: widget.userId,
          );
          BlocProvider.of<StoryEventCubit>(context)
              .fire(event: StoryEvent.GO_PREVIOUS_STORY);
        } else if (position > width * 0.7) {
          widget.onTickCallback(1);
          timer.cancel();
          BlocProvider.of<AppDataCubit>(context).addSeenStory(
            storyId: widget.storyId,
            userId: widget.userId,
          );
          BlocProvider.of<StoryEventCubit>(context)
              .fire(event: StoryEvent.GO_NEXT_STORY);
        }
      },
      onLongPress: () {
        timer.cancel();
        BlocProvider.of<StoryEventCubit>(context)
            .fire(event: StoryEvent.ON_HOLD);
      },
      onLongPressEnd: (details) {
        timer = Timer.periodic(
          const Duration(milliseconds: 5),
          (timer) {
            if (timerLength.inMilliseconds > 0) {
              timerLength -= const Duration(milliseconds: 5);
              final elapsed = timeToCompare - timerLength;
              widget.onTickCallback(
                elapsed.inMilliseconds / timeToCompare.inMilliseconds,
              );
            } else {
              timer.cancel();
              widget.onTickCallback(1);
              widget.onEndCallback();
            }
          },
        );
        BlocProvider.of<StoryEventCubit>(context)
            .fire(event: StoryEvent.RESUMED);
      },
      child: SafeArea(
        child: widget.imgUrl.isEmpty
            ? SizedBox(
                width: width,
                height: height,
                child: const Text(
                  "Error loading story, please try again later...",
                  textAlign: TextAlign.center,
                ),
              )
            : Image.network(
                widget.imgUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.white,
                      size: 36,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      "Error loading story, please try again later...",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
