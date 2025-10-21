
class CustomersResponseModel {
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

  CustomersResponseModel({required this.brandName, required this.phone, required this.mail, required this.mobile, required this.accountCode, required this.customerToken, required this.contact, required this.description, required this.companyName, required this.country});

  factory CustomersResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomersResponseModel(
      brandName: json["brandName"],
      phone: json["phone"],
      mail: json["mail"],
      mobile: json["mobile"],
      accountCode: json["accountCode"],
      customerToken: json["customerToken"],
      contact: json["contact"],
      description: json["description"],
      companyName: json["companyName"],
      country: json["country"]
    );
  }

  static List<CustomersResponseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CustomersResponseModel.fromJson(json)).toList();
  }

}
