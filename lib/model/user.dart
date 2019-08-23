class User {
  final String id;
  final String login;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;

  User(
      {this.id,
      this.login,
      this.email,
      this.role,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      login: json['login'],
      email: json['email'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'email': email,
        'role': role,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  @override
  String toString() {
    return '\nid = ' +
        id +
        '\login = ' +
        login +
        '\nemail = ' +
        email +
        '\nrole = ' +
        role +
        '\ncreatedAt = ' +
        createdAt +
        '\nupdatedAt = ' +
        updatedAt;
  }
}
