import 'package:flutter/material.dart';
import 'package:recetario_relacional/databases/database.dart';
import 'package:recetario_relacional/pantallas/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String _error = '';

  void _iniciarSesion() async {
    String correo = _correoController.text.trim();
    String contrasena = _contrasenaController.text;

    var usuario = await _databaseHelper.obtenerUsuario(correo, contrasena);

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(usuarioId: usuario['id'])),
      );
    } else {
      setState(() {
        _error = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Imagenes/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: "PlayfairDisplay",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 320,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Usuario',
                            style: TextStyle(
                              fontFamily: "PlayfairDisplay",
                              fontSize: 15,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 300,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: _correoController,
                              decoration: InputDecoration(
                                errorText: _error.isNotEmpty ? _error : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                prefixIcon: Icon(Icons.person, color: Colors.grey),
                                hintText: 'Ingrese su usuario',
                                hintStyle: TextStyle(
                                  fontFamily: "PlayfairDisplay",
                                  color: Colors.black54,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Contraseña',
                            style: TextStyle(
                              fontFamily: "PlayfairDisplay",
                              fontSize: 15,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 300,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: _contrasenaController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                                hintText: 'Ingrese su contraseña',
                                hintStyle: TextStyle(
                                  fontFamily: "PlayfairDisplay",
                                  color: Colors.black54,
                                ),
                              ),
                              obscureText: true,
                              style: TextStyle(
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: _iniciarSesion,
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registro'); 
                            },
                            child: Text(
                              'Crear una cuenta',
                              style: TextStyle(
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
