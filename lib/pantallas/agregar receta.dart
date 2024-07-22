import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetario_relacional/databases/database.dart';
import 'package:recetario_relacional/modelos/receta.dart';

class AddRecipeScreen extends StatefulWidget {
  final int usuarioId;
  AddRecipeScreen({required this.usuarioId});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _pasosController = TextEditingController();
  final TextEditingController _tiempoPreparacionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  File? _imagenReceta;
  String? _categoriaSeleccionada;

  final List<String> _categorias = ['Bebidas', 'Entrada', 'Plato Principal', 'Postre'];

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenReceta = File(pickedFile.path);
      });
    }
  }

  void _agregarReceta() async {
    String titulo = _tituloController.text.trim();
    String ingredientes = _ingredientesController.text.trim();
    String pasos = _pasosController.text.trim();
    String tiempoPreparacionTexto = _tiempoPreparacionController.text.trim();
    String? categoria = _categoriaSeleccionada;

    if (titulo.isEmpty || ingredientes.isEmpty || pasos.isEmpty || tiempoPreparacionTexto.isEmpty || categoria == null) {
      _mostrarError('Por favor, complete todos los campos');
      return;
    }

    int? tiempoPreparacion = int.tryParse(tiempoPreparacionTexto);
    if (tiempoPreparacion == null) {
      _mostrarError('Por favor, ingrese un tiempo de preparación válido');
      return;
    }

    Receta nuevaReceta = Receta(
      id: 0,
      usuarioId: widget.usuarioId,
      titulo: titulo,
      ingredientes: ingredientes,
      pasos: pasos,
      tiempoPreparacion: tiempoPreparacion,
      categoria: categoria,
      rutaImagen: _imagenReceta?.path ?? '',
    );

    await _databaseHelper.insertarReceta(nuevaReceta);

    _mostrarMensaje('Receta agregada exitosamente');
    Navigator.pop(context);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 105, 105), 
        title: Text('Agregar Receta'),
      ),
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
                      _buildTextField("Título: ", _tituloController, Icons.title_outlined),
                      SizedBox(height: 21),
                      _buildTextField("Ingredientes: ", _ingredientesController, Icons.food_bank_outlined, maxLines: 4),
                      SizedBox(height: 21),
                      _buildTextField("Pasos: ", _pasosController, Icons.do_not_step_sharp, maxLines: 4),
                      SizedBox(height: 21),
                      _buildTextField("Tiempo de Preparación (minutos): ", _tiempoPreparacionController, Icons.timer, isNumber: true),
                      SizedBox(height: 21),
                      _buildDropdown(),
                      SizedBox(height: 21),
                      ElevatedButton(
                        onPressed: _seleccionarImagen,
                        child: Text(
                          'Selecciona una Imagen',
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      _imagenReceta != null
                          ? Image.file(
                              _imagenReceta!,
                              height: 400.0,
                              width: 400.0,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                      SizedBox(height: 21),
                      ElevatedButton(
                        onPressed: _agregarReceta,
                        child: Text(
                          'Agregar Receta',
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

  Widget _buildTextField(String labelText, TextEditingController controller, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            labelText,
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
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black),
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
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}
