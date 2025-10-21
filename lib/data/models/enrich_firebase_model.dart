

class EnrichFirebaseModel {
  final String category;
  final String description;
  final String epc;
  final String gtin;
  final String imageUrl;
  final String price;
  final String sku;
  
  EnrichFirebaseModel({required this.category, required this.description, required this.epc, required this.gtin, required this.imageUrl, required this.price, required this.sku});


  factory EnrichFirebaseModel.fromMap(Map<String, dynamic> data) {
    return EnrichFirebaseModel(
      category: data['category'] ?? '', 
      description: data['description'] ?? '',
      epc: data['epc'] ?? '',
      gtin: data['gtin'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? '',
      sku: data['sku'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'epc': epc,
      'gtin': gtin,
      'imageUrl': imageUrl,
      'price': price,
      'sku': sku,
    };
  }
}
