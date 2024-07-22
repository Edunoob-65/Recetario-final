
class User {
  int id;
  String correo;
  String contrasena;

  User({required this.id, required this.correo, required this.contrasena});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'correo': correo,
      'contrasena': contrasena,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      correo: map['correo'],
      contrasena: map['contrasena'],
    );
  }
}

