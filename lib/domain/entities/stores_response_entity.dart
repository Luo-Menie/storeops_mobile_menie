


import 'dart:convert';

class StoresResponseEntity {
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

  Map<String, dynamic> toMap() {
    return {
     'close': close,
     'storeToken': storeToken,
     'accountId': accountId,
     'storeName': storeName,
     'postalCode': postalCode,
     'county': county,
     'customerIdStore': customerIdStore,
     'latitude': latitude,
     'longitude': longitude,
     'storeId': storeId,
     'city': city,
     'address': address,
     'state': state,
     'country': country,
     'groups': groups
    };
  }

  factory StoresResponseEntity.fromMap(Map<String, dynamic> map) {
    return StoresResponseEntity(
      close: map['close'] ?? false, 
      storeToken: map['storeToken'] ?? '',
      accountId: map['accountId'] ?? '',
      storeName: map['storeName'] ?? '',
      postalCode: map['postalCode'] ?? '',
      county: map['county'] ?? '',
      customerIdStore: map['customerIdStore'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      storeId: map['storeId'] ?? '', 
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      groups: map['groups'] ?? []
    );
  }


  String toJson() => json.encode(toMap());

  factory StoresResponseEntity.fromJson(String source) =>
      StoresResponseEntity.fromMap(json.decode(source));

  StoresResponseEntity({required this.close, required this.storeToken, required this.accountId, required this.storeName, required this.postalCode, required this.county, required this.customerIdStore, required this.latitude, required this.longitude, required this.storeId, required this.city, required this.address, required this.state, required this.country, required this.groups});


}