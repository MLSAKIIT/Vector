class NewPasswordViewModel {
  String password = '';
  String confirmPassword = '';

  void setPassword(String value) {
    password = value;
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
  }

  bool passwordsMatch() {
    return password == confirmPassword;
  }
}
