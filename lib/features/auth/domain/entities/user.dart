import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {

  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String fullName;

  User({
    required this.userId,
    required this.email,
    required this.fullName,
  });

}