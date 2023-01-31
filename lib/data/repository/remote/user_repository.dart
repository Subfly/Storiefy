import 'package:story_way/data/dto/user_dto.dart';

import '../../dao/user_dao.dart';
import '../../service/app_database_service.dart';

class UserRepository implements UserDAO {
  final AppDatabaseService service;

  UserRepository({required this.service});

  @override
  Future<UserDTO?> getUserById({required int userId}) {
    return service.fetchUserDataById(id: userId);
  }

  @override
  Future<List<UserDTO>> getUsers() {
    return service.fetchUsersData();
  }
}
