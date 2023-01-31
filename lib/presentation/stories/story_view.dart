import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_way/common/constants/hero_tags.dart';
import 'package:story_way/common/enums/content_type.dart';
import 'package:story_way/domain/state/data/app_data_cubit.dart';
import 'package:story_way/presentation/stories/components/main_pager.dart';
import 'package:story_way/presentation/stories/state/story_event_cubit.dart';

import '../../domain/state/data/app_data_state.dart';

class StoryViewArguments {
  final int id;
  final int selectedIndex;

  const StoryViewArguments({
    required this.id,
    required this.selectedIndex,
  });
}

class StoryView extends StatefulWidget {
  static const route = "/stories";
  final StoryViewArguments arguments;
  const StoryView({
    super.key,
    required this.arguments,
  });

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  Color _bgColor = Colors.black;
  double _sizeFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    final storyView = BlocBuilder<AppDataCubit, AppDataState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.errorMessage.isNotEmpty) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          return BlocProvider<StoryEventCubit>(
            create: (context) => StoryEventCubit(),
            child: MainPager(
              selectedIndex: widget.arguments.selectedIndex,
              stories: state.stories,
              positionChangeCallback: (changePercentage) {
                setState(() {
                  _bgColor = _bgColor.withOpacity(changePercentage);
                  _sizeFactor = 1.0 * changePercentage;
                });
              },
            ),
          );
        }
      },
    );
    return Hero(
      tag: "${HeroTags.STORY_TAG}${widget.arguments.id}",
      transitionOnUserGestures: true,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: _bgColor,
        body: Dismissible(
          key: const Key("story_key"),
          direction: DismissDirection.down,
          onDismissed: (direction) {
            Navigator.of(context).pop();
          },
          dismissThresholds: const {DismissDirection.down: 0.2},
          crossAxisEndOffset: MediaQuery.of(context).size.height * 0.8,
          child: AnimatedScale(
            duration: const Duration(microseconds: 0),
            scale: _sizeFactor,
            child: storyView,
          ),
        ),
      ),
    );
  }
}
