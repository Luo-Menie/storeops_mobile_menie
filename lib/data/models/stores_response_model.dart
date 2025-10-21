

class StoresResponseModel {
    final bool close;
    final String storeToken;
    final String accountId;
    final String storeName;
    final String postalCode;
    final String county;
    final String customerIdStore;
    final String latitude;
    final String longitude;
    final String storeId;
    final String city;
    final String address;
    final String state;
    final String country;
    final List<dynamic> groups;


 
  factory StoresResponseModel.fromJson(Map<String, dynamic> json) {
    return StoresResponseModel(
      close: json["close"] == null ? false : json["close"]!, 
      storeToken: json["storeToken"] == null ? '' : json["storeToken"]!,  
      accountId: json["accountId"] == null ? '' : json["accountId"]!, 
      storeName: json["storeName"] == null ? '' : json["storeName"]!,  
      postalCode: json["postalCode"] == null ? '' : json["postalCode"]!, 
      county: json["county"] == null ? '' : json["county"]!, 
      customerIdStore: json["customerIdStore"] == null ? '' : json["customerIdStore"]!, 
      latitude: json["latitude"] == null ? '' : json["latitude"]!, 
      longitude: json["longitude"] == null ? '' : json["longitude"]!, 
      storeId: json["storeId"] == null ? '' : json["storeId"]!, 
      city: json["city"] == null ? '' : json["city"]!, 
      address: json["address"] == null ? '' : json["address"]!, 
      state: json["state"] == null ? '' : json["state"]!, 
      country: json["country"] == null ? '' : json["country"]!,
      groups: json["groups"] == null ? [] : json["groups"]!
    );
  }

  StoresResponseModel({required this.close, required this.storeToken, required this.accountId, required this.storeName, required this.postalCode, required this.county, required this.customerIdStore, required this.latitude, required this.longitude, required this.storeId, required this.city, required this.address, required this.state, required this.country, required this.groups});


  static List<StoresResponseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StoresResponseModel.fromJson(json)).toList();
  }
}
