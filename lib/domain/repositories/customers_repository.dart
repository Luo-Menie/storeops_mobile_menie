
import 'package:storeops_mobile/domain/entities/customer_response_entity.dart';

abstract class CustomerRepository  {
  Future<List<CustomerResponseEntity>> customer();
}
