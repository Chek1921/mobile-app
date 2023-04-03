class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() =>{
    "username": this.username, 
    "password": this.password,
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
