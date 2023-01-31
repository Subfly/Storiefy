import 'package:hive/hive.dart';
import 'package:story_way/common/constants/preferences_constants.dart';
import 'package:story_way/data/repository/local/preferences_repository.dart';

class PreferencesRepositoryHiveImpl implements PreferencesRepository {
  final HiveInterface _hive = Hive;

  @override
  Future<void> clear() async {
    final box = await _hive.openBox(PreferencesConstants.PREFERENCES_NAME);
    await box.deleteFromDisk();
  }

  @override
  Future<T?> getPreference<T>({
    required String key,
    required T? defaultValue,
  }) async {
    final box = await _hive.openBox(PreferencesConstants.PREFERENCES_NAME);
    return await box.get(
      key,
      defaultValue: defaultValue,
    ) as T?;
  }

  @override
  Future<void> setPreference<T>({
    required String key,
    required T value,
  }) async {
    final box = await _hive.openBox(PreferencesConstants.PREFERENCES_NAME);
    await box.put(key, value);
  }
}
