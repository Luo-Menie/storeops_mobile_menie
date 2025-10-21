import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginResponseEntity> login(user,password) async {
    final model = await remoteDataSource.login(user, password);
    return LoginResponseEntity(
      id: model.id == null ? 0 : model.id!,
      username: model.username == null ? '' : model.username!,
      email: model.email == null ? '' : model.email!,
      roles: model.roles == null ? List.empty() : model.roles!,
      mobileAccess: model.mobileAccess == null ? false : model.mobileAccess!,
      tokenType: model.tokenType == null ? '' : model.tokenType!,
      accessToken: model.accessToken == null ? '' : model.accessToken!,
      message: model.message == null ? '' : model.message!
    );
  }
}
