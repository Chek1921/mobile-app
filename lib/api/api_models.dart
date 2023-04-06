class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() =>{
    "username": username, 
    "password": password,
    };
}

class Token {
  String token;
  String refreshToken;

  Token({required this.token, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        token: json['access'].toString(),
        refreshToken: json['refresh'].toString());
  }
}

class UserRegistration {
  String username;
  String email;
  String password1;
  String password2;
  String address;
  int districtId;

  UserRegistration({required this.username, required this.email, required this.password1, required this.password2, required this.address, required this.districtId});

  Map<String, dynamic> toDatabaseJson() =>{
    "username": username, 
    "email": email,
    "password1": password1,
    "password2": password2,
    "address": address,
    "district_id": districtId,
    };
}

class UserForgot {
  String email;

  UserForgot({required this.email});

  Map<String, dynamic> toDatabaseJson() =>{
    "email": email,
    };
}