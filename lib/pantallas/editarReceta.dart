import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetario_relacional/databases/database.dart';
import 'package:recetario_relacional/modelos/receta.dart';

class EditRecipeScreen extends StatefulWidget {
  final int usuarioId;
  final Receta receta;

  EditRecipeScreen({required this.usuarioId, required this.receta});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _pasosController = TextEditingController();
  final TextEditingController _tiempoPreparacionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();
  String? _categoriaSeleccionada;

  final List<String> _categorias = ['Bebidas', 'Entrada', 'Plato Principal', 'Postre'];

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.receta.titulo;
    _ingredientesController.text = widget.receta.ingredientes;
    _pasosController.text = widget.receta.pasos;
    _tiempoPreparacionController.text = widget.receta.tiempoPreparacion.toString();
    _categoriaSeleccionada = widget.receta.categoria;
    if (widget.receta.rutaImagen.isNotEmpty) {
      _imagenSeleccionada = File(widget.receta.rutaImagen);
    }
  }

  Future<void> _seleccionarImagen() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenSeleccionada = File(pickedFile.path);
      });
    }
  }

  void _actualizarReceta() async {
    String titulo = _tituloController.text.trim();
    String ingredientes = _ingredientesController.text.trim();
    String pasos = _pasosController.text.trim();
    String? categoria = _categoriaSeleccionada;
    String tiempoPreparacionTexto = _tiempoPreparacionController.text.trim();
    String rutaImagen = _imagenSeleccionada?.path ?? widget.receta.rutaImagen;

    if (titulo.isEmpty || ingredientes.isEmpty || pasos.isEmpty || categoria == null || tiempoPreparacionTexto.isEmpty) {
      _mostrarError('Por favor, complete todos los campos');
      return;
    }

    int? tiempoPreparacion = int.tryParse(tiempoPreparacionTexto);
    if (tiempoPreparacion == null) {
      _mostrarError('Por favor, ingrese un tiempo de preparación válido');
      return;
    }

    Receta recetaActualizada = Receta(
      id: widget.receta.id,
      usuarioId: widget.usuarioId,
      titulo: titulo,
      ingredientes: ingredientes,
      pasos: pasos,
      tiempoPreparacion: tiempoPreparacion,
      categoria: categoria,
      rutaImagen: rutaImagen,
    );

    int resultado = await _databaseHelper.actualizarReceta(recetaActualizada);

    if (resultado != -1) {
      _mostrarMensaje('Receta actualizada exitosamente');
      Navigator.pop(context, 'actualizar');
    } else {
      _mostrarError('Error al actualizar la receta');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Imagenes/fondo.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _imagenSeleccionada != null
                          ? Image.file(
                              _imagenSeleccionada!,
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 200.0,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(
                                  'No hay imagen seleccionada',
                                  style: TextStyle(
                                    fontFamily: 'PlayfairDisplay',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: _seleccionarImagen,
                        child: Text(
                          'Cambiar imagen',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Título: ",
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      TextField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.title_outlined, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: "Escribe aqui",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 21),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Ingredientes: ",
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      TextField(
                        controller: _ingredientesController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.food_bank_outlined, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: "Escribe aqui",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                      SizedBox(height: 21),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Pasos: ",
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      TextField(
                        controller: _pasosController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.do_not_step_sharp, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: "Escribe aqui",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                      SizedBox(height: 21),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Tiempo de Preparación (minutos): ",
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      TextField(
                        controller: _tiempoPreparacionController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.timer, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: "Escribe aqui",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 21),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Categoría: ",
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      DropdownButtonFormField<String>(
                        value: _categoriaSeleccionada,
                        onChanged: (String? newValue) {
                          setState(() {
                            _categoriaSeleccionada = newValue;
                          });
                        },
                        items: _categorias.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.category_outlined, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: "Seleccione una categoría",
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 21),
                      ElevatedButton(
                        onPressed: _actualizarReceta,
                        child: Text(
                          'Actualizar Receta',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
