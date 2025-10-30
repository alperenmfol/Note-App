import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  static const String userBox = 'userBox';

  Future<void> saveUser(User user) async {
    final box = await Hive.openBox<User>(userBox);
    await box.put('currentUser', user);
  }

  Future<User?> getUser() async {
    final box = await Hive.openBox<User>(userBox);
    return box.get('currentUser');
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox<User>(userBox);
    await box.delete('currentUser');
  }
}
