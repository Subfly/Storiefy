import 'package:story_way/common/constants/preferences_constants.dart';

enum PreferencesType {
  HIVE,
  SHARED_PREFS;

  String getValue() {
    switch (this) {
      case PreferencesType.HIVE:
        return PreferencesConstants.HIVE;
      case PreferencesType.SHARED_PREFS:
        return PreferencesConstants.SHARED_PREFS;
    }
  }

  @override
  String toString() {
    return getValue().toUpperCase();
  }
}
