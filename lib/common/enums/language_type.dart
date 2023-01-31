import 'package:story_way/common/constants/preferences_constants.dart';

enum LanguageType {
  TR,
  EN;

  String getValue() {
    switch (this) {
      case LanguageType.TR:
        return PreferencesConstants.TR;
      case LanguageType.EN:
        return PreferencesConstants.EN;
    }
  }

  @override
  String toString() {
    return getValue().toUpperCase();
  }
}
