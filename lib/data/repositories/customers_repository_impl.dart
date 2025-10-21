

import 'package:storeops_mobile/data/sources/customers_datasource.dart';
import 'package:storeops_mobile/domain/entities/customer_response_entity.dart';
import 'package:storeops_mobile/domain/repositories/customers_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomersDatasource remoteDataSource;

  CustomerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CustomerResponseEntity>> customer() async {
    final models = await remoteDataSource.customer();

    return models.map((model) => CustomerResponseEntity(
      brandName: model.brandName,
      phone: model.phone,
      mail: model.mail,
      mobile: model.mobile,
      accountCode: model.accountCode,
      customerToken: model.customerToken,
      contact: model.contact,
      description: model.description,
      companyName: model.companyName,
      country: model.country
    )).toList();
  }
  
}
