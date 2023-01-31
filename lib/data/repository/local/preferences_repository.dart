abstract class PreferencesRepository {
  Future<T?> getPreference<T>({
    required String key,
    required T? defaultValue,
  });
  Future<void> setPreference<T>({
    required String key,
    required T value,
  });
  Future<void> clear();
}
