
import '../models/login_response_model.dart';
import '../../../core/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource(this.dioClient);

  Future<LoginResponse> login(String username, String password) async {
    final response = await dioClient.dio.post(
      '/auth/signin',
      data: {
        'username': username,
        'password': password,
      },
    );

    final model = LoginResponse.fromJson(response.data);
    return model;
  }
}
