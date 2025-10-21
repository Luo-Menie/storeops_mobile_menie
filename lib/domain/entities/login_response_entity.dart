

class  LoginResponseEntity{

  final int id;
  final String username;
  final String email;
  final List roles;
  final bool mobileAccess;
  final String tokenType;
  final String accessToken;
  final String message;

  LoginResponseEntity({required this.id, required this.username, required this.email, required this.roles, required this.mobileAccess, required this.tokenType, required this.accessToken, required this.message});
  
}