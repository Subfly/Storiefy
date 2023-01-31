import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_way/common/enums/content_type.dart';
import 'package:story_way/presentation/home/components/post_tile.dart';
import 'package:story_way/presentation/home/components/profile_image.dart';
import 'package:story_way/presentation/profile/state/profile_cubit.dart';
import 'package:story_way/presentation/profile/state/profile_state.dart';
import 'package:story_way/presentation/stories/story_view.dart';

class ProfileViewArguments {
  final int userId;
  final String userName;

  const ProfileViewArguments({
    required this.userId,
    required this.userName,
  });
}

class ProfileView extends StatelessWidget {
  static const String route = "/profile";
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileViewArguments props =
        ModalRoute.of(context)?.settings.arguments as ProfileViewArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          props.userName,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Feather.chevron_left,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: BlocProvider(
        create: (context) {
          final cubit = ProfileCubit();
          cubit.init(userId: props.userId);
          return cubit;
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.white,
                  size: 36,
                ),
              );
            } else if (state.errorMessage.isNotEmpty) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  headerSliverBuilder: (_, __) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          ProfileImage(
                                            imageUrl:
                                                state.user?.profilePic ?? "",
                                            backgroundSize: 40,
                                            foregroundSize: 40,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            props.userName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      )),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "${state.user?.postIds.length}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                state.posts.length == 1
                                                    ? "Post"
                                                    : "Posts",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "${state.stories?.stories.length}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                state.stories?.stories.length ==
                                                        1
                                                    ? "Stroy"
                                                    : "Stories",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "${Random().nextInt(500) + 1}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const Text(
                                                "Followers",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      TabBar(
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            icon: Icon(
                              FontAwesome5Solid.photo_video,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MaterialCommunityIcons.post_outline,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TabBarView(
                            children: [
                              GridView.count(
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 3,
                                childAspectRatio: 0.65,
                                children: state.stories?.stories.map(
                                      (element) {
                                        switch (element.type) {
                                          case ContentType.IMAGE:
                                            return Image.network(
                                              element.url ?? "",
                                              fit: BoxFit.cover,
                                            );
                                          case ContentType.VIDEO:
                                            return Container(
                                              color: Colors.black,
                                              child: const Center(
                                                child: Icon(Feather.video),
                                              ),
                                            );
                                          default:
                                            return Container(
                                              color: Colors.black,
                                            );
                                        }
                                      },
                                    ).toList() ??
                                    [],
                              ),
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.posts.length,
                                itemBuilder: (context, index) {
                                  return PostTile(
                                    model: state.posts[index],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
