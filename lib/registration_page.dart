import 'package:flutter/material.dart';
import 'api_register.dart';
import 'home_page.dart';


class RegistrationPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final ApiService _apiService = ApiService();


  void _register(BuildContext context) async {
    // Agrega aquí la lógica para el registro de usuario.
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String celular = _celularController.text;
      String dni = _dniController.text;

      final token = await _apiService.registerUser(name, email, password, celular, dni);

      if (token != null) {
        // El registro fue exitoso, puedes redirigir al usuario a otra pantalla o realizar otras acciones
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      } else {
        // Maneja el caso en que el registro no sea exitoso, por ejemplo, muestra un mensaje de error
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _celularController,
              decoration: InputDecoration(
                labelText: 'Celular',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dniController,
              decoration: InputDecoration(
                labelText: 'DNI',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { 
                _register(context);
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
