

import 'package:storeops_mobile/domain/entities/login_response_entity.dart';

abstract class AuthRepository  {
  Future<LoginResponseEntity> login(String username, String password);
}
