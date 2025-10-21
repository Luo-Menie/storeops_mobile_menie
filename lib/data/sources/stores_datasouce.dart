import 'package:storeops_mobile/core/dio_client.dart';
import 'package:storeops_mobile/data/models/stores_response_model.dart';


class StoresDatasource {
  final DioClient dioClient;

  StoresDatasource({required this.dioClient});

  Future<List<StoresResponseModel>> stores(String customerToken) async {
    final response = await dioClient.dio.get('/v1/stores/$customerToken');
    if(response.statusCode==200){
      final model = StoresResponseModel.fromJsonList(response.data);
      return model;
    }
    else {
      return [];
    }
  }
}