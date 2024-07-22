import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recetario_relacional/databases/database.dart';
import 'package:recetario_relacional/modelos/receta.dart';
import 'package:recetario_relacional/pantallas/editarReceta.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Receta receta;
  final int usuarioId;

  RecipeDetailScreen({required this.receta, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color.fromARGB(255, 192, 161, 119),
      appBar: AppBar(
        title: Text(
          receta.titulo,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 201, 105, 105), 
        actions: [
          IconButton(
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipeScreen(
                    usuarioId: usuarioId,
                    receta: receta,
                  ),
                ),
              );

              if (resultado == 'actualizar') {
                Navigator.pop(context, 'actualizar');
              }
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              bool confirmarEliminar = await _dialogoConfirmacionEliminacion(context);
              if (confirmarEliminar) {
                final dbHelper = DatabaseHelper();
                if (receta.id != null) {  // Asegúrate de que receta.id no sea null
                  int result = await dbHelper.eliminarReceta(receta.id!);
                  if (result != -1) {
                    Navigator.pop(context, 'eliminar');
                    _mostrarMensaje(context, 'Receta eliminada exitosamente');
                  } else {
                    _mostrarError(context, 'Error al eliminar la receta');
                  }
                } else {
                  _mostrarError(context, 'ID de receta no válido');
                }
              }
            },
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8E8D1), Color.fromARGB(255, 192, 161, 119)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (receta.rutaImagen.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    File(receta.rutaImagen),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8.0)],
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.deepOrange),
                    SizedBox(width: 8.0),
                    Text(
                      '${receta.tiempoPreparacion} minutos',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'PlayfairDisplay',
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              _buildSectionTitle('Ingredientes:'),
              _buildCard(
                content: receta.ingredientes,
              ),
              SizedBox(height: 16.0),
              _buildSectionTitle('Pasos:'),
              _buildCard(
                content: receta.pasos,
              ),
              SizedBox(height: 16.0),
              _buildSectionTitle('Categoría:'),
              _buildCard(
                content: receta.categoria,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'PlayfairDisplay',
        color: Colors.deepOrange,
      ),
    );
  }

  Widget _buildCard({required String content}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8.0)],
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'PlayfairDisplay',
        ),
      ),
    );
  }

  Future<bool> _dialogoConfirmacionEliminacion(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación', style: TextStyle(fontFamily: 'PlayfairDisplay')),
          content: Text('¿Estás seguro de que deseas eliminar esta receta?', style: TextStyle(fontFamily: 'PlayfairDisplay')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar', style: TextStyle(fontFamily: 'PlayfairDisplay')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Eliminar', style: TextStyle(fontFamily: 'PlayfairDisplay')),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: TextStyle(fontFamily: 'PlayfairDisplay')),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: TextStyle(fontFamily: 'PlayfairDisplay')),
        backgroundColor: Colors.green,
      ),
    );
  }
}
