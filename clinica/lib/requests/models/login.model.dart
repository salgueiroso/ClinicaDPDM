class LoginItem {
  final String login;
  final String senha;

  LoginItem({this.login, this.senha});

  factory LoginItem.fromJson(Map<String, dynamic> json) =>
      LoginItem(login: json['login'], senha: json['senha']);

  Map<String, dynamic> toJson() => {
        'login': login,
        'senha': senha,
      };
}
