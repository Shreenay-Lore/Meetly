import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meetly/core/model/either.dart';
import 'package:meetly/core/model/failure.dart';
import 'package:meetly/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:meetly/features/auth/domain/entity/user_entity.dart';
import 'package:meetly/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final GoogleSignIn googleSignIn;

  AuthRepositoryImpl(
      {required this.authRemoteDatasource, required this.googleSignIn});

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try{
      // Initialize GoogleSignIn (required in v7.x)
      await googleSignIn.initialize();

      // Authenticate the user
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      
      if (googleUser == null) {
        return Left(AuthFailure(message: 'Sign in cancelled'));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create Firebase credential with the ID token
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final firebaseCredentials = await FirebaseAuth.instance.signInWithCredential(credential);

      final token = await firebaseCredentials.user?.getIdToken();

      if(token!=null){
        return Right(await authRemoteDatasource.signInWithGoogle(token));
      }
      else{
        return Left(AuthFailure(message: 'Auth Failure'));
      }
    }
    on DioException catch (e){
      return Left(AuthFailure(message: e.response?.data['message']));
    }
    catch (e){
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      return Right(null);
    }
    catch (e){
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
