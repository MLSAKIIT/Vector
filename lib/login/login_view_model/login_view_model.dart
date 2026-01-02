class LoginViewModel {
  String username = '';
  String password = '';

  void updateUsername(String value) {
    username = value;
  }

  void updatePassword(String value) {
    password = value;
  }

  bool isValid() {
    return username.isNotEmpty && password.isNotEmpty;
  }
}
