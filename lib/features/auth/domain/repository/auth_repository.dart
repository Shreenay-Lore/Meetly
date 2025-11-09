import 'package:meetly/core/model/either.dart';
import 'package:meetly/core/model/failure.dart';
import 'package:meetly/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository{
  Future<Either<Failure,UserEntity>> signInWithGoogle();
  Future<Either<Failure,void>> logOut();
}