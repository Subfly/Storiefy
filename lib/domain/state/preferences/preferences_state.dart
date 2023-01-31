import 'package:equatable/equatable.dart';
import 'package:story_way/common/enums/language_type.dart';
import 'package:story_way/common/enums/theme_selection_type.dart';

class PreferencesState extends Equatable {
  final ThemeSelectionType themeSelectionType;
  final LanguageType languageType;
  final bool isLoading;
  final String errorMessage;

  const PreferencesState({
    required this.themeSelectionType,
    required this.languageType,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [themeSelectionType, languageType];

  PreferencesState copy({
    ThemeSelectionType? themeSelectionType,
    LanguageType? languageType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PreferencesState(
      themeSelectionType: themeSelectionType ?? this.themeSelectionType,
      languageType: languageType ?? this.languageType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
