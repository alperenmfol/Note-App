import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  static const String userBox = 'userBox';

  Future<Box<User>> _openBox() async {
    if (!Hive.isBoxOpen(userBox)) {
      return await Hive.openBox<User>(userBox);
    }
    return Hive.box<User>(userBox);
  }

  Future<void> saveUser(User user) async {
    final box = await _openBox();
    await box.put('currentUser', user);
  }

  Future<User?> getUser() async {
    final box = await _openBox();
    return box.get('currentUser');
  }

  Future<void> clearUser() async {
    final box = await _openBox();
    await box.delete('currentUser');
  }
}
