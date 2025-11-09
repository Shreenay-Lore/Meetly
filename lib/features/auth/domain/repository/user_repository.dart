import 'dart:io';

import 'package:meetly/core/model/either.dart';
import 'package:meetly/core/model/failure.dart';
import 'package:meetly/features/auth/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser();

  Future<Either<Failure, void>> editUser(
      {required String name, required String bio, File? avatar});
}
