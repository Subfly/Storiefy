import 'package:story_way/common/constants/preferences_constants.dart';

enum DatabaseType {
  HIVE,
  SQFLITE;

  String getValue() {
    switch (this) {
      case DatabaseType.HIVE:
        return PreferencesConstants.HIVE;
      case DatabaseType.SQFLITE:
        return PreferencesConstants.SQFLITE;
    }
  }

  @override
  String toString() {
    return getValue().toUpperCase();
  }
}
