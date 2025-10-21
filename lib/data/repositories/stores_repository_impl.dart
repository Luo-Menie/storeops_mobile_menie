


import 'package:storeops_mobile/data/sources/stores_datasouce.dart';
import 'package:storeops_mobile/domain/entities/stores_response_entity.dart';
import 'package:storeops_mobile/domain/repositories/stores_repository.dart';

class StoresRepositoryImpl implements StoresRepository {
  final StoresDatasource remoteDataSource;


  StoresRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StoresResponseEntity>> stores(customerToken) async {
    final models = await remoteDataSource.stores(customerToken);

    return models.map((model) => StoresResponseEntity(
      close: model.close, 
      storeToken: model.storeToken, 
      accountId: model.accountId, 
      storeName: model.storeName, 
      postalCode: model.postalCode, 
      county: model.county, 
      customerIdStore: model.customerIdStore, 
      latitude: model.latitude, 
      longitude: model.longitude, 
      storeId: model.storeId, 
      city: model.city, 
      address: model.address, 
      state: model.state, 
      country: model.country,
      groups: model.groups
    )).toList();
  }
  
}
