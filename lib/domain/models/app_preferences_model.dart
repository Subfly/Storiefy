import 'package:equatable/equatable.dart';

import '../../common/enums/language_type.dart';
import '../../common/enums/theme_selection_type.dart';

class AppPreferencesModel extends Equatable {
  final LanguageType language;
  final ThemeSelectionType themeSelection;

  const AppPreferencesModel({
    required this.language,
    required this.themeSelection,
  });

  @override
  List<Object?> get props => [language, themeSelection];

  AppPreferencesModel copy({
    LanguageType? language,
    ThemeSelectionType? themeSelection,
  }) {
    return AppPreferencesModel(
      language: language ?? this.language,
      themeSelection: themeSelection ?? this.themeSelection,
    );
  }
}
