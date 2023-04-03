class UserStatusCode {
  int name;
  late String message;
  UserStatusCode({required this.name});

  factory UserStatusCode.fromName(int name) {
    UserStatusCode statusCode = UserStatusCode(name: name);
    if (statusCode.name == 200) {
      statusCode.message = '';
    } else if (statusCode.name == 401) {
      statusCode.message = 'Ошибка в имени пользователя или пароле';
    } else {
      statusCode.message = 'Неизвестаня ошибка';
    }
    return statusCode;
  }
}