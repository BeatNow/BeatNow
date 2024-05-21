import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BeatNow/Models/UserSingleton.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreen createState() => _SavedScreen();
}

class _SavedScreen extends  State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Beats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212), // sombra más oscura
              Color(0xFF0D0D0D), // incluso más oscura
            ],
            stops: [0.5, 1.0], // dónde comenzar y terminar cada color
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.5, // Proporción 2:1 (alto:ancho)
          ),
          itemCount: 30, // Cantidad de elementos en la cuadrícula (ajusta según sea necesario)
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey, // Color de fondo temporal
              child: Center(
                child: Text('Item $index',
                    style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ),
    );
  }
}
