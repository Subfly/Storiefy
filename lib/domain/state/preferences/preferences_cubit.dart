import 'package:bloc/bloc.dart';
import 'package:story_way/common/constants/preferences_constants.dart';
import 'package:story_way/common/enums/language_type.dart';
import 'package:story_way/common/enums/theme_selection_type.dart';
import 'package:story_way/data/repository/local/preferences_repository.dart';
import 'package:story_way/domain/state/preferences/preferences_state.dart';

class PreferencesCubit extends Cubit<PreferencesState> {
  final PreferencesRepository _repo;
  PreferencesCubit(this._repo)
      : super(
          const PreferencesState(
            themeSelectionType: ThemeSelectionType.AUTO,
            languageType: LanguageType.EN,
            isLoading: true,
            errorMessage: "",
          ),
        );

  Future<void> init() async {
    ThemeSelectionType selectedTheme;
    LanguageType selectedLanguage;

    // Get values in prefs
    final themeInPrefs = await _repo.getPreference<String?>(
      key: PreferencesConstants.THEME_SELECTION,
      defaultValue: null,
    );
    final langInPrefs = await _repo.getPreference<String>(
      key: PreferencesConstants.LANGUAGE_SELECTION,
      defaultValue: null,
    );

    // Set values or defaults if not exists
    if (themeInPrefs != null) {
      switch (themeInPrefs) {
        case PreferencesConstants.AUTO:
          selectedTheme = ThemeSelectionType.AUTO;
          break;
        case PreferencesConstants.LIGHT:
          selectedTheme = ThemeSelectionType.LIGHT;
          break;
        case PreferencesConstants.DARK:
          selectedTheme = ThemeSelectionType.DARK;
          break;
        default:
          selectedTheme = ThemeSelectionType.AUTO;
          break;
      }
    } else {
      await _repo.setPreference(
        key: PreferencesConstants.THEME_SELECTION,
        value: ThemeSelectionType.AUTO.getValue(),
      );
      selectedTheme = ThemeSelectionType.AUTO;
    }

    if (langInPrefs != null) {
      switch (langInPrefs) {
        case PreferencesConstants.EN:
          selectedLanguage = LanguageType.EN;
          break;
        case PreferencesConstants.TR:
          selectedLanguage = LanguageType.TR;
          break;
        default:
          selectedLanguage = LanguageType.EN;
          break;
      }
    } else {
      await _repo.setPreference(
        key: PreferencesConstants.LANGUAGE_SELECTION,
        value: LanguageType.EN.getValue(),
      );
      selectedLanguage = LanguageType.EN;
    }

    // Emit State
    emit(
      state.copy(
        themeSelectionType: selectedTheme,
        languageType: selectedLanguage,
        isLoading: false,
        errorMessage: "",
      ),
    );
  }

  Future<void> changeTheme({required ThemeSelectionType newTheme}) async {
    await _repo.setPreference(
      key: PreferencesConstants.THEME_SELECTION,
      value: newTheme.getValue(),
    );
    emit(
      state.copy(
        themeSelectionType: newTheme,
      ),
    );
  }

  Future<void> changeLanguage({required LanguageType newLanguage}) async {
    await _repo.setPreference(
      key: PreferencesConstants.LANGUAGE_SELECTION,
      value: newLanguage.getValue(),
    );
    emit(
      state.copy(
        languageType: newLanguage,
      ),
    );
  }
}
