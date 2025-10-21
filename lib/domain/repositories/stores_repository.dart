

import 'package:storeops_mobile/domain/entities/stores_response_entity.dart';

abstract class StoresRepository  {
  Future<List<StoresResponseEntity>> stores(String customerToken);
}
