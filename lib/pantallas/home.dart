import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recetario_relacional/databases/database.dart';
import 'package:recetario_relacional/modelos/receta.dart';
import 'package:recetario_relacional/pantallas/agregar%20receta.dart';
import 'package:recetario_relacional/pantallas/detallereceta.dart';
import 'package:recetario_relacional/pantallas/login.dart';

class HomeScreen extends StatefulWidget {
  final int usuarioId;

  HomeScreen({required this.usuarioId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Receta> _recetas = [];
  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    _cargarRecetas();
  }

  Future<void> _cargarRecetas() async {
    List<Receta> recetas = await _databaseHelper.obtenerRecetasPorUsuario(widget.usuarioId);
    setState(() {
      if (_selectedCategory == 'Todos') {
        _recetas = recetas;
      } else {
        _recetas = recetas.where((receta) => receta.categoria == _selectedCategory).toList();
      }
    });
  }

  void _navegarDetalles(Receta receta) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          receta: receta,
          usuarioId: widget.usuarioId,
        ),
      ),
    );

    if (resultado == 'actualizar' || resultado == 'eliminar') {
      _cargarRecetas();
    }
  }

  Future<ImageProvider> _cargarImagen(String rutaImagen) async {
    final file = File(rutaImagen);
    if (await file.exists()) {
      return FileImage(file);
    } else {
      return AssetImage('assets/default_image.png');
    }
  }

  void _cerrarSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colorPalette = [
      Color.fromARGB(255, 173, 162, 62)!,
      const Color.fromARGB(255, 146, 116, 71)!,
      Color.fromARGB(255, 247, 154, 91)!,
      Color.fromARGB(255, 240, 77, 77)!,
      Colors.orange[500]!,
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF8E8D1),
      appBar: AppBar(
        title: Text(
          'Recetas',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 201, 105, 105), 
        actions: [
          IconButton(
            onPressed: _cerrarSesion,
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: _recetas.isEmpty
                      ? Center(
                          child: Text(
                            'Aún no tienes recetas guardadas',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _recetas.length,
                          itemBuilder: (context, index) {
                            Receta receta = _recetas[index];
                            final color = colorPalette[index % colorPalette.length];
                            return GestureDetector(
                                 onTap: () => _navegarDetalles(receta),
                              child: Container(
                                width: 330.0, 
                                margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), // Margen reducido
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: color, //
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0),
                                          bottomLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      elevation: 10,
                                      child: Stack(
                                        clipBehavior: Clip.none, 
                                        children: [
                                          // 
                                          
                                          Container(
                                            width: 285.0,
                                            height: 400.0, 
                                            child: Stack(
                                              clipBehavior: Clip.none, // Esto se usa para permitir el desbordamiento de la imagen receta
                                              children: [
                                                Positioned(
                                                  right: -50.0, 
                                                  top: -10.0,
                                                  child: FutureBuilder<ImageProvider>(
                                                    future: _cargarImagen(receta.rutaImagen),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.done) {
                                                        return ClipOval(
                                                          child: Container(
                                                            width: 200.0, 
                                                            height: 200.0, 
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: snapshot.data!,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(
                                                          width: 200.0,
                                                          height: 200.0,
                                                          color: Colors.grey[300],
                                                          child: Center(child: CircularProgressIndicator()),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                   
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    color: Colors.transparent, // Fondo transparente
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          receta.titulo,
                                                          style: TextStyle(
                                                            fontFamily: 'PlayfairDisplay',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 24.0,
                                                            color: Colors.white, // Color del texto
                                                          ),
                                                          textAlign: TextAlign.left, // Alinear texto a la izquierda
                                                        ),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          receta.categoria,
                                                          style: TextStyle(
                                                            fontFamily: 'PlayfairDisplay',
                                                            color: Colors.white, // Color del texto
                                                            fontSize: 14.0,
                                                          ),
                                                          textAlign: TextAlign.left, 
                                                        ),
                                                      ],
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
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 150.0, 
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoriaBoton('Todos'),
                    SizedBox(width: 4.0), 
                    _categoriaBoton('Bebidas'),
                    SizedBox(width: 4.0), 
                    _categoriaBoton('Entrada'),
                    SizedBox(width: 4.0),
                    _categoriaBoton('Plato Principal'),
                    SizedBox(width: 4.0), 
                    _categoriaBoton('Postre'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(usuarioId: widget.usuarioId),
            ),
          ).then((_) {
            _cargarRecetas();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 201, 105, 105), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _categoriaBoton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
          _cargarRecetas();
        });
      },
      child: Text(
        category,
        style: TextStyle(
          color: Colors.white, 
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 197, 162, 48), 
        minimumSize: Size(120, 50),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), 
        ),
      ),
    );
  }
}
