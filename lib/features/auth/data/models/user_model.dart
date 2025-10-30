import 'package:note_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.email,
    required super.fullName,
  });
}
