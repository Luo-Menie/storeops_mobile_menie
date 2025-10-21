

class LoginResponse {
  final int? id;
  final String? username;
  final String? email;
  final List<String>? roles;
  final bool? mobileAccess;
  final String? tokenType;
  final String? accessToken;
  final String? message;

  LoginResponse({required this.id, this.username, this.email, this.roles, this.mobileAccess, this.tokenType, this.accessToken, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    
    return LoginResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      mobileAccess: json['mobileAccess'] ?? false,
      tokenType: json['tokenType'] ?? '',
      accessToken: json['accessToken'] ?? '',
      message: json['message'] ?? '',
    );
  }


  bool get isSuccess => accessToken != null && accessToken!.isNotEmpty;
}
