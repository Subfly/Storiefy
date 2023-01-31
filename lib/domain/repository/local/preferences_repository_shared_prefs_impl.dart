import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_way/data/repository/local/preferences_repository.dart';

class PreferencesRepositorySharedPrefsImpl implements PreferencesRepository {
  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<T?> getPreference<T>({
    required String key,
    required T? defaultValue,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }

  /// Notes from developer:
  /// Why I did not used num instead of int or double?
  /// I believe it is obvious :d
  /// Even though num is the superclass of both int and double,
  /// preferences store types independent.
  @override
  Future<void> setPreference<T>({
    required String key,
    required T value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case String:
        prefs.setString(key, value as String);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      default:
        throw TypeError();
    }
  }
}
