import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'dart:convert';
import 'api_register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String token = ''; // Aquí almacena el token del usuario logueado.

  final String baseUrl = 'http://localhost:8000'; // Reemplaza con la URL de tu API

  @override
  void initState() {
    super.initState();

    
    Future<String?> getUserNameFromApi() async {
      final apiService = ApiService(); // Crea una instancia de ApiService.
      return await apiService.getUserName();
    }
    
    // Llama a la función para obtener el nombre del usuario    
    getUserNameFromApi().then((String? userName) {
        if (userName != null) {
          setState(() {
            this.userName = userName; // Asigna el nombre del usuario a la variable de estado 'userName'.
          });
        }
    });


    // Función para obtener el token del almacenamiento seguro.
    Future<String?> getTokenFromStorage() async {
      final apiService = ApiService(); // Crea una instancia de ApiService.
      return await apiService.getToken();
    }

    // Llama a la función para obtener el token del usuario logueado.
    getTokenFromStorage().then((String? token) {
      if (token != null) {
        setState(() {
          this.token = token; // Asigna el token obtenido a la variable de estado 'token'.
        });
      }
    });
  
    // ... Aquí obtén el token y el nombre del usuario ...

    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¡Tu Responsabilidad Salva Vidas! 🚨'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Utiliza esta aplicación con prudencia y solo en situaciones de emergencia genuina. El abuso de esta herramienta afecta la capacidad de respuesta de la policía y pone en riesgo a quienes realmente necesitan ayuda. Juntos, podemos hacer de nuestra comunidad un lugar más seguro. #UsaConResponsabilidad 🤝.',
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    });
  }

  // Función para enviar la solicitud POST al servidor
  Future<void> sendSOS(String tipo) async {
    final sosUrl = Uri.parse('$baseUrl/api/create/sos');
    final date = DateTime.now();

     // Obten la posición del dispositivo
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final body = {
      // "latitud": "-3.7527771967517936",
      // "longitud": "-73.25753145926325",
      "latitud": position.latitude.toString(),
      "longitud": position.longitude.toString(),
      "tipo": tipo.toString(),
      "fecha": "${date.year}-${date.month}-${date.day}",
      "hora": "${date.hour}:${date.minute}:${date.second}",
    };

    final response = await http.post(
      sosUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Agrega el token de autorización
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // La solicitud se envió con éxito, puedes manejar la respuesta según tus necesidades.
      showSuccessDialog(context); // Muestra el diálogo de éxito
    } else {
      // Hubo un error al enviar la solicitud, puedes manejar los errores aquí.
      showSuccessDialog(context); // Muestra el diálogo de error
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alerta Enviada'),
          content: Text('Tu alerta ha sido enviada con éxito. Ayuda está en camino.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alerta Error'),
          content: Text('Tu envío no se pudo procesar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergencia SOS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hola, $userName', // Muestra el nombre del usuario
              style: TextStyle(fontSize: 19),
            ),
            Text(
              '¡Usa la app con responsabilidad.!',
              style: TextStyle(fontSize: 20),
            ),
            
            SizedBox(height: 20),
            EmergencyButton(
              label: 'Policía',
              imageAsset: '../assets/police.png',
              onPressed: () {
                // Al presionar el botón "Policía", envía una solicitud SOS de tipo "policía".
                sendSOS('policía');
              },
            ),
            SizedBox(height: 10),
            EmergencyButton(
              label: 'Bomberos',
              imageAsset: '../assets/fireman.png',
              onPressed: () {
                // Al presionar el botón "Bomberos", envía una solicitud SOS de tipo "bomberos".
                sendSOS('bomberos');
              },
            ),
            SizedBox(height: 10),
            EmergencyButton(
              label: 'Ambulancia',
              imageAsset: '../assets/ambulance.png',
              onPressed: () {
                // Al presionar el botón "Ambulancia", envía una solicitud SOS de tipo "ambulancia".
                sendSOS('ambulancia');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyButton extends StatelessWidget {
  final String label;
  final String imageAsset;
  final VoidCallback onPressed;

  EmergencyButton({
    required this.label,
    required this.imageAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.red, // Puedes cambiar el color de fondo aquí
      ),
      child: Column(
        children: <Widget>[
          Image.asset(
            imageAsset,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}

