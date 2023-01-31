import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_way/presentation/stories/state/story_event_cubit.dart';
import 'package:story_way/presentation/stories/state/story_event_state.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/state/data/app_data_cubit.dart';

class VideoStoryComponent extends StatefulWidget {
  final String storyId;
  final int userId;
  final String videoUrl;
  final Function(double completion) onTickCallback;
  final Function onEndCallback;

  const VideoStoryComponent({
    super.key,
    required this.storyId,
    required this.userId,
    required this.videoUrl,
    required this.onTickCallback,
    required this.onEndCallback,
  });

  @override
  State<VideoStoryComponent> createState() => _VideoStoryComponentState();
}

class _VideoStoryComponentState extends State<VideoStoryComponent> {
  Duration timeToCompare = const Duration(milliseconds: 0);
  late Duration timerLength;
  late VideoPlayerController _controller;
  Timer timer = Timer.periodic(const Duration(seconds: 0), (timer) {
    // Do nothing..
    // This is here for late init, otherwise app were crashing...
  });
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl);
    _controller.initialize().then(
      (value) {
        if (mounted) {
          if (timeToCompare == const Duration(milliseconds: 0)) {
            timeToCompare = _controller.value.duration;
          }
          timerLength = _controller.value.duration;
          timer = Timer.periodic(
            const Duration(milliseconds: 5),
            (timer) {
              if (timerLength.inMilliseconds > 0) {
                timerLength -= const Duration(milliseconds: 5);
                final elapsed = timeToCompare - timerLength;
                widget.onTickCallback(
                  elapsed.inMilliseconds / timeToCompare.inMilliseconds,
                );
                if (elapsed > const Duration(milliseconds: 2500)) {
                  BlocProvider.of<AppDataCubit>(context).addSeenStory(
                    storyId: widget.storyId,
                    userId: widget.userId,
                  );
                }
              } else {
                widget.onTickCallback(1);
                timer.cancel();
                _controller.pause();
                BlocProvider.of<AppDataCubit>(context).addSeenStory(
                  storyId: widget.storyId,
                  userId: widget.userId,
                );
                widget.onEndCallback();
              }
            },
          );
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
          _controller.pause();

          BlocProvider.of<AppDataCubit>(context).addSeenStory(
            storyId: widget.storyId,
            userId: widget.userId,
          );
          BlocProvider.of<StoryEventCubit>(context)
              .fire(event: StoryEvent.GO_PREVIOUS_STORY);
        } else if (position > width * 0.7) {
          widget.onTickCallback(1);
          timer.cancel();
          _controller.pause();

          BlocProvider.of<AppDataCubit>(context).addSeenStory(
            storyId: widget.storyId,
            userId: widget.userId,
          );
          BlocProvider.of<StoryEventCubit>(context)
              .fire(event: StoryEvent.GO_NEXT_STORY);
        }
      },
      onLongPress: () {
        _controller.pause();
        timer.cancel();
        BlocProvider.of<StoryEventCubit>(context)
            .fire(event: StoryEvent.ON_HOLD);
      },
      onLongPressEnd: (details) {
        _controller.play();
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
            }
          },
        );
        BlocProvider.of<StoryEventCubit>(context)
            .fire(event: StoryEvent.RESUMED);
      },
      child: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: _isInitialized
              ? VideoPlayer(_controller)
              : Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: 36,
                  ),
                ),
        ),
      ),
    );
  }
}
