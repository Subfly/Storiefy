import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_way/common/constants/preferences_constants.dart';
import 'package:story_way/common/enums/database_type.dart';
import 'package:story_way/common/enums/language_type.dart';
import 'package:story_way/common/enums/preferences_type.dart';
import 'package:story_way/common/enums/theme_selection_type.dart';
import 'app_preferences_state.dart';

class MainCubit extends Cubit<AppPreferencesState> {
  MainCubit()
      : super(
          const AppPreferencesState(
            preferencesType: PreferencesType.HIVE,
            databaseType: DatabaseType.HIVE,
            isLoading: true,
            errorMessage: "",
          ),
        );

  Future<void> init() async {
    // Locate params
    PreferencesType prefsType;
    DatabaseType databaseType;

    // Get prefs
    final prefs = await SharedPreferences.getInstance();
    final selectedPreferenceTypeStr =
        prefs.getString(PreferencesConstants.PREFERENCES_SELECTION);
    final selectedDatabaseTypeStr =
        prefs.getString(PreferencesConstants.DATABASE_SELECTION);

    // Set values or defaults if not exists
    if (selectedPreferenceTypeStr == PreferencesType.HIVE.getValue()) {
      prefsType = PreferencesType.HIVE;
    } else if (selectedPreferenceTypeStr ==
        PreferencesType.SHARED_PREFS.getValue()) {
      prefsType = PreferencesType.SHARED_PREFS;
    } else {
      prefs.setString(
        PreferencesConstants.PREFERENCES_SELECTION,
        PreferencesType.HIVE.getValue(),
      );
      prefsType = PreferencesType.HIVE;
    }

    if (selectedDatabaseTypeStr == DatabaseType.HIVE.getValue()) {
      databaseType = DatabaseType.HIVE;
    } else if (selectedDatabaseTypeStr == DatabaseType.SQFLITE.getValue()) {
      databaseType = DatabaseType.SQFLITE;
    } else {
      prefs.setString(
        PreferencesConstants.DATABASE_SELECTION,
        PreferencesType.HIVE.getValue(),
      );
      databaseType = DatabaseType.HIVE;
    }
    
    // Emit State
    emit(state.copy(
      preferencesType: prefsType,
      databaseType: databaseType,
      isLoading: false,
    ));
  }

  Future<void> setPreferredPreferenceProvider(
    PreferencesType newPreferenceProvider,
  ) async {
    // Apply failsafe
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      PreferencesConstants.PREFERENCES_SELECTION,
      newPreferenceProvider.getValue(),
    );

    // Change state
    emit(state.copy(preferencesType: newPreferenceProvider));
  }

  Future<void> setPreferredDatabaseProvider(
    DatabaseType newDatabaseProvider,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      PreferencesConstants.DATABASE_SELECTION,
      newDatabaseProvider.getValue(),
    );
    // Change state
    emit(state.copy(databaseType: newDatabaseProvider));
  }
}
