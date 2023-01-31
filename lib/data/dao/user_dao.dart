import '../dto/user_dto.dart';

abstract class UserDAO {
  Future<List<UserDTO>> getUsers();
  Future<UserDTO?> getUserById({required int userId});
}