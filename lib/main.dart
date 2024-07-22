import 'package:flutter/material.dart';
import 'package:recetario_relacional/pantallas/agregar%20receta.dart';
import 'package:recetario_relacional/pantallas/login.dart';
import 'package:recetario_relacional/pantallas/registro.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get usuarioId => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetario Personal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/registro': (context) => RegisterScreen(),
        '/agregarReceta': (context) => AddRecipeScreen(usuarioId: usuarioId),
      },
    );
  }
}
