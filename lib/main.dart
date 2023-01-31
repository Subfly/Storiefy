import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:story_way/common/enums/database_type.dart';
import 'package:story_way/common/enums/preferences_type.dart';
import 'package:story_way/domain/repository/local/preferences_repository_hive_impl.dart';
import 'package:story_way/domain/repository/local/preferences_repository_shared_prefs_impl.dart';
import 'package:story_way/domain/repository/local/story_database_repository_hive_impl.dart';
import 'package:story_way/domain/repository/local/story_database_repository_sqflite_impl.dart';
import 'package:story_way/domain/state/data/app_data_cubit.dart';
import 'package:story_way/domain/state/preferences/preferences_cubit.dart';
import 'package:story_way/presentation/home/home_view.dart';
import 'package:story_way/presentation/profile/profile_view.dart';
import 'package:story_way/presentation/settings/settings_view.dart';
import 'package:story_way/presentation/empty/empty_view.dart';
import 'package:story_way/presentation/stories/story_view.dart';

import 'common/enums/language_type.dart';
import 'common/enums/theme_selection_type.dart';
import 'domain/state/main/app_preferences_state.dart';
import 'domain/state/main/main_cubit.dart';
import 'domain/state/preferences/preferences_state.dart';

void main() async {
  await Hive.initFlutter();
  await StoryDatabaseRepositorySqfliteImpl.initStoriesDB();
  runApp(const StoryWayApp());
}

class StoryWayApp extends StatefulWidget {
  const StoryWayApp({super.key});

  @override
  State<StoryWayApp> createState() => _StoryWayAppState();
}

class _StoryWayAppState extends State<StoryWayApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (context) {
        final cubit = MainCubit();
        cubit.init();
        return cubit;
      },
      // I have tried to implement some sort of live dependency injection here...
      child: BlocBuilder<MainCubit, AppPreferencesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const EmptyView();
          } else if (state.errorMessage.isNotEmpty) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            // Normally, apps start from here...
            return MultiBlocProvider(
              providers: [
                BlocProvider<PreferencesCubit>(
                  create: (context) {
                    final preferencesType = BlocProvider.of<MainCubit>(context)
                        .state
                        .preferencesType;
                    final cubit = PreferencesCubit(
                      preferencesType == PreferencesType.SHARED_PREFS
                          ? PreferencesRepositorySharedPrefsImpl()
                          : PreferencesRepositoryHiveImpl(),
                    );
                    cubit.init();
                    return cubit;
                  },
                ),
                BlocProvider<AppDataCubit>(
                  create: (context) {
                    final storageType =
                        BlocProvider.of<MainCubit>(context).state.databaseType;
                    final cubit = AppDataCubit(
                      storageType == DatabaseType.SQFLITE
                          ? StoryDatabaseRepositorySqfliteImpl()
                          : StoryDatabaseRepositoryHiveImpl(),
                    );
                    cubit.init();
                    return cubit;
                  },
                ),
              ],
              child: BlocBuilder<PreferencesCubit, PreferencesState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const EmptyView();
                  } else if (state.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else {
                    ThemeMode themeMode;
                    switch (state.themeSelectionType) {
                      case ThemeSelectionType.LIGHT:
                        themeMode = ThemeMode.light;
                        break;
                      case ThemeSelectionType.DARK:
                        themeMode = ThemeMode.dark;
                        break;
                      case ThemeSelectionType.AUTO:
                        themeMode = ThemeMode.system;
                        break;
                    }

                    Locale appLocale;
                    switch (state.languageType) {
                      case LanguageType.TR:
                        appLocale = const Locale("tr", "TR");
                        break;
                      case LanguageType.EN:
                        appLocale = const Locale("en", "US");
                        break;
                    }

                    return MaterialApp(
                      title: 'StoryWay',
                      locale: appLocale,
                      themeMode: themeMode,
                      theme: ThemeData(
                        brightness: Brightness.light,
                        primaryColor: Colors.black,
                        textTheme: GoogleFonts.quicksandTextTheme().apply(
                          bodyColor: const Color(0xFF040B39),
                        ),
                        scaffoldBackgroundColor: Colors.white,
                      ),
                      darkTheme: ThemeData(
                        brightness: Brightness.dark,
                        primaryColor: Colors.white,
                        textTheme: GoogleFonts.quicksandTextTheme().apply(
                          bodyColor: Colors.white,
                        ),
                        scaffoldBackgroundColor: const Color(0xFF16172A),
                      ),
                      initialRoute: HomeView.route,
                      routes: {
                        EmptyView.route: (context) => const EmptyView(),
                        HomeView.route: (context) => const HomeView(),
                        SettingsView.route: (context) => const SettingsView(),
                        ProfileView.route: (context) => const ProfileView(),
                      },
                      onGenerateRoute: (settings) {
                        if (settings.name == StoryView.route) {
                          final args =
                              settings.arguments as StoryViewArguments?;
                          if (args != null) {
                            return PageRouteBuilder(
                              pageBuilder: (_, __, ___) => StoryView(
                                arguments: args,
                              ),
                              opaque: false,
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
