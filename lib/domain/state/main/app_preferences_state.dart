import 'package:equatable/equatable.dart';
import 'package:story_way/common/enums/database_type.dart';
import 'package:story_way/common/enums/language_type.dart';
import 'package:story_way/common/enums/preferences_type.dart';
import 'package:story_way/common/enums/theme_selection_type.dart';

class AppPreferencesState extends Equatable {
  final PreferencesType preferencesType;
  final DatabaseType databaseType;
  final bool isLoading;
  final String errorMessage;

  const AppPreferencesState({
    required this.preferencesType,
    required this.databaseType,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [preferencesType, databaseType];

  AppPreferencesState copy({
    PreferencesType? preferencesType,
    DatabaseType? databaseType,
    ThemeSelectionType? themeSelectionType,
    LanguageType? languageType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppPreferencesState(
      preferencesType: preferencesType ?? this.preferencesType,
      databaseType: databaseType ?? this.databaseType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
