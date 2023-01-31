import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_way/common/components/settings_selection_dialog.dart';
import 'package:story_way/common/enums/database_type.dart';
import 'package:story_way/common/enums/language_type.dart';
import 'package:story_way/common/enums/preferences_type.dart';
import 'package:story_way/common/enums/theme_selection_type.dart';
import 'package:story_way/domain/state/main/app_preferences_state.dart';
import 'package:story_way/domain/state/main/main_cubit.dart';
import 'package:story_way/domain/state/preferences/preferences_cubit.dart';
import 'package:story_way/domain/state/preferences/preferences_state.dart';

class SettingsView extends StatelessWidget {
  static const String route = "/settings";

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
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
      body: Column(
        children: [
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Injection Preferences",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              } else if (index == 1) {
                return ListTile(
                  title: const Text(
                    "Preferences Injection: ",
                  ),
                  trailing: Text(
                    context.watch<MainCubit>().state.preferencesType.name,
                  ),
                  onTap: () {
                    createSettingsSelectionDialog(
                      context: context,
                      title: "Change Injected Preference",
                      currentSelectedValue:
                          context.read<MainCubit>().state.preferencesType,
                      selections: [
                        PreferencesType.HIVE,
                        PreferencesType.SHARED_PREFS,
                      ],
                      onValueSelected: (newValue) {
                        if (newValue != null) {
                          BlocProvider.of<MainCubit>(context)
                              .setPreferredPreferenceProvider(newValue);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Restart required to apply recent change",
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Restart",
                                onPressed: () {},
                              ),
                              duration: const Duration(seconds: 300),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              } else {
                return ListTile(
                  title: const Text(
                    "Database Injection: ",
                  ),
                  trailing: Text(
                    context.watch<MainCubit>().state.databaseType.name,
                  ),
                  onTap: () {
                    createSettingsSelectionDialog(
                      context: context,
                      title: "Change Injected Database",
                      currentSelectedValue:
                          context.read<MainCubit>().state.databaseType,
                      selections: [
                        DatabaseType.HIVE,
                        DatabaseType.SQFLITE,
                      ],
                      onValueSelected: (newValue) {
                        if (newValue != null) {
                          BlocProvider.of<MainCubit>(context)
                              .setPreferredDatabaseProvider(newValue);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Restart required to make changes available",
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Restart",
                                onPressed: () {},
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "App Preferences",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                );
              } else if (index == 1) {
                return ListTile(
                  title: const Text(
                    "Theme Preference: ",
                  ),
                  trailing: Text(
                    context
                        .watch<PreferencesCubit>()
                        .state
                        .themeSelectionType
                        .name,
                  ),
                  onTap: () {
                    createSettingsSelectionDialog(
                      context: context,
                      title: "Change Preferred Theme",
                      currentSelectedValue: context
                          .read<PreferencesCubit>()
                          .state
                          .themeSelectionType,
                      selections: [
                        ThemeSelectionType.AUTO,
                        ThemeSelectionType.LIGHT,
                        ThemeSelectionType.DARK,
                      ],
                      onValueSelected: (newValue) {
                        if (newValue != null) {
                          BlocProvider.of<PreferencesCubit>(context)
                              .changeTheme(newTheme: newValue);
                        }
                      },
                    );
                  },
                );
              } else {
                return ListTile(
                  title: const Text(
                    "Language Preference: ",
                  ),
                  trailing: Text(
                    context.watch<PreferencesCubit>().state.languageType.name,
                  ),
                  onTap: () {
                    createSettingsSelectionDialog(
                      context: context,
                      title: "Change Preferred Language",
                      currentSelectedValue:
                          context.read<PreferencesCubit>().state.languageType,
                      selections: [
                        LanguageType.EN,
                        LanguageType.TR,
                      ],
                      onValueSelected: (newValue) {
                        if (newValue != null) {
                          BlocProvider.of<PreferencesCubit>(context)
                              .changeLanguage(newLanguage: newValue);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Coming soon... Or maybe not...",
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 24,
                            ),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: "Sounds OK!",
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
