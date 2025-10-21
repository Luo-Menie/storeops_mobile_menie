import 'dart:convert';

class CustomerResponseEntity {
  final String brandName;
  final String phone;
  final String mail;
  final String mobile;
  final String accountCode;
  final String customerToken;
  final String contact;
  final String description;
  final String companyName;
  final String country;

  CustomerResponseEntity({
    required this.brandName,
    required this.phone,
    required this.mail,
    required this.mobile,
    required this.accountCode,
    required this.customerToken,
    required this.contact,
    required this.description,
    required this.companyName,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'brandName': brandName,
      'phone': phone,
      'mail': mail,
      'mobile': mobile,
      'accountCode': accountCode,
      'customerToken': customerToken,
      'contact': contact,
      'description': description,
      'companyName': companyName,
      'country': country,
    };
  }

  factory CustomerResponseEntity.fromMap(Map<String, dynamic> map) {
    return CustomerResponseEntity(
      brandName: map['brandName'] ?? '',
      phone: map['phone'] ?? '',
      mail: map['mail'] ?? '',
      mobile: map['mobile'] ?? '',
      accountCode: map['accountCode'] ?? '',
      customerToken: map['customerToken'] ?? '',
      contact: map['contact'] ?? '',
      description: map['description'] ?? '',
      companyName: map['companyName'] ?? '',
      country: map['country'] ?? '',
    );
  }


  String toJson() => json.encode(toMap());

  factory CustomerResponseEntity.fromJson(String source) =>
      CustomerResponseEntity.fromMap(json.decode(source));
}
