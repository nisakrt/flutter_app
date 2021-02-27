class Login{
  String username;
  String password;
  Login({
    this.username,
    this.password,
  });
  factory Login.fromJson(Map<String, dynamic> parsedJson){
    return Login(
      username: parsedJson['username'],
      password : parsedJson['password'],
    );
  }
}