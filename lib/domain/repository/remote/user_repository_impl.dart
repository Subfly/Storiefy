import 'package:story_way/data/service/app_database_service.dart';
import 'package:story_way/domain/models/user_model.dart';

import '../../../data/repository/remote/user_repository.dart';

class UserRepositoryImpl {

  late UserRepository _repo;

  UserRepositoryImpl(AppDatabaseService service) {
    _repo = UserRepository(service: service);
  }

  Future<List<UserModel>> getUsers() async {
    final users = await _repo.getUsers();
    return users.map((e) => UserModel.fromDTO(dto: e)).toList();
  }

  Future<UserModel?> getUserById({required int userId}) async {
    final userDto = await _repo.getUserById(userId: userId); 
    if(userDto == null) {
      return null;
    }
    return UserModel.fromDTO(dto: userDto);
  }
}