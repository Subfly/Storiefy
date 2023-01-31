import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:story_way/domain/state/data/app_data_cubit.dart';
import 'package:story_way/domain/state/data/app_data_state.dart';
import 'package:story_way/presentation/home/components/post_tile.dart';
import 'package:story_way/presentation/home/components/stories_row.dart';
import 'package:story_way/presentation/profile/profile_view.dart';
import 'package:story_way/presentation/settings/settings_view.dart';
import 'package:story_way/presentation/stories/story_view.dart';

class HomeView extends StatelessWidget {
  static const String route = "/home";

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "StoryWay",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            final state = BlocProvider.of<AppDataCubit>(context).state;
            Navigator.of(context).pushNamed(
              ProfileView.route,
              arguments: ProfileViewArguments(
                userId: state.currentUser?.id ?? -1,
                userName: state.currentUser?.userName ?? "",
              ),
            );
          },
          icon: Icon(
            Feather.user,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsView.route);
            },
            icon: Icon(
              Feather.settings,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: BlocBuilder<AppDataCubit, AppDataState>(
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
            return ListView.separated(
              itemCount: state.stories.isNotEmpty
                  ? 1 + state.posts.length
                  : state.posts.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: StoriesRow(
                      stories: state.stories,
                      onStoryPressed: (index) {
                        Navigator.of(context).pushNamed(
                          StoryView.route,
                          arguments: StoryViewArguments(
                            id: state.stories[index].id,
                            selectedIndex: index,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return PostTile(
                    model: state.posts[index - 1],
                  );
                }
              },
              separatorBuilder: (_, __) {
                return const SizedBox(
                  height: 16,
                );
              },
            );
          }
        },
      ),
    );
  }
}
