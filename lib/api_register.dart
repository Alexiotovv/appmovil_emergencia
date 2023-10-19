import 'dart:convert';
import 'package:http/http.dart' as http;


// import 'package:flutter_secure_storage/flutter_secure_storage';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8000'; // Reemplaza con la URL de tu API

  Future<String?> registerUser(
      String name, String email, String password, String celular, String dni) async {
    final registerUrl = Uri.parse('$baseUrl/api/register'); // Reemplaza 'register' con el endpoint de registro de tu API

    try {
      final response = await http.post(
        registerUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'celular': celular,
          'dni': dni,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token']; // Suponiendo que la API devuelve un token
        
        // Llama a la función para guardar el token
        await saveToken(token);

        return token;
      } else {
        // Maneja los errores según sea necesario
        return null;
      }
    } catch (e) {
      // Maneja las excepciones según sea necesario 
        return null;
    }
  }

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();


  Future<String?> loginUser(String email, String password) async {
  final loginUrl = Uri.parse('$baseUrl/api/login'); // Reemplaza 'login' con el endpoint de inicio de sesión de tu API

  try {
    final response = await http.post(
      loginUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['access_token']; // Suponiendo que la API devuelve un token

      // Llama a la función para guardar el token
      await saveToken(token);

      return token;
    } else {
      // Maneja los errores según sea necesario (por ejemplo, si las credenciales son incorrectas)
      return null;
    }
  } catch (e) {
    // Maneja las excepciones según sea necesario (por ejemplo, si hay un problema de red)
    return null;
  }
}

Future<String?> getUserName() async {
  final token = await getToken();
  if (token != null) {
    final userUrl = Uri.parse('$baseUrl/api/infouser'); // Reemplaza 'user' con el endpoint para obtener información del usuario
    try {
      final response = await http.get(
        userUrl,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userName = responseData['name']; // Asume que el campo del nombre del usuario se llama 'name'
        return userName;
      }
    } catch (e) {
      // Maneja las excepciones según sea necesario
    }
  }
  return null;
}


  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'token');
  }
}
