class LoginItem {
  final String Login;
  final String Senha;

  LoginItem({this.Login, this.Senha});

  factory LoginItem.fromJson(Map<String, dynamic> json) =>
      LoginItem(Login: json['login'], Senha: json['senha']);

  Map<String, dynamic> toJson() => {
        'login': Login,
        'senha': Senha,
      };
}
