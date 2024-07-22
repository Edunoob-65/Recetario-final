import 'package:flutter/material.dart';

import 'package:recetario_relacional/databases/database.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String _error = '';

  void _registrar() async {
    String correo = _correoController.text.trim();
    String contrasena = _contrasenaController.text;

    // Validar que los campos no estén vacíos
    if (correo.isEmpty || contrasena.isEmpty) {
      setState(() {
        _error = 'Debe completar todos los campos';
      });
      return;
    }

    // Verificando si el usuario ya existe
    var usuarioExistente = await _databaseHelper.obtenerUsuario(correo, contrasena);
    if (usuarioExistente != null) {
      setState(() {
        _error = 'El usuario ya existe';
      });
      return;
    }

    await _databaseHelper.registrarUsuario(correo, contrasena);

    // Navegar a la pantalla de inicio de sesión
    Navigator.pushReplacementNamed(context, '/');
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
                      Icons.file_upload_outlined,
                      color: Colors.white,
                      size: 50,
                ),     
                  ),
                  SizedBox(height: 10),       
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Regístrate',
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
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nombre del usuario',
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
                            SizedBox(height: 5),
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
                            SizedBox(height: 45),
                            ElevatedButton(
                              onPressed: _registrar,
                              child: Text(
                                'Registrar',
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),),
   ]),
   );
  }
}
