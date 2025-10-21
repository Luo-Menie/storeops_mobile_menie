

import 'package:storeops_mobile/core/dio_client.dart';
import 'package:storeops_mobile/data/models/customers_response_model.dart';

class CustomersDatasource {
  final DioClient dioClient;

  CustomersDatasource({required this.dioClient});

  Future<List<CustomersResponseModel>> customer() async {
    final response = await dioClient.dio.get('/v1/customers');
    if(response.statusCode == 200){
      final model = CustomersResponseModel.fromJsonList(response.data);
      return model;
    }
    else{
      return [];
    }
    
  }
}