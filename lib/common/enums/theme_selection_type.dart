import 'package:story_way/common/constants/preferences_constants.dart';

enum ThemeSelectionType {
  LIGHT,
  DARK,
  AUTO;

  String getValue() {
    switch(this) {
      case ThemeSelectionType.LIGHT:
        return PreferencesConstants.LIGHT;
      case ThemeSelectionType.DARK:
        return PreferencesConstants.DARK;
      case ThemeSelectionType.AUTO:
        return PreferencesConstants.AUTO;
    }
  }

  @override
  String toString() {
    return getValue().toUpperCase();
  }
}