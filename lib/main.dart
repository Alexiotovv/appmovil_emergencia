import 'package:flutter/material.dart';
import 'registration_page.dart'; // Importa el archivo de registro de usuario
import 'api_register.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyLoginPage(title: 'Login'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title});

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  void checkAuthenticationStatus() async {
    final token = await _apiService.getToken();

    if (token != null) {
      // Si el token existe, redirige al usuario a la página de inicio
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void _login() async {
  // Agrega aquí la lógica para el inicio de sesión, por ejemplo, validar credenciales.
  String email = _emailController.text;
  String password = _passwordController.text;

  final token = await _apiService.loginUser(email, password);

  if (token != null) {
    // El inicio de sesión fue exitoso, puedes redirigir al usuario a la página de inicio
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  } else {
    // Maneja el caso en que el inicio de sesión no sea exitoso, por ejemplo, muestra un mensaje de error
    final snackBar = SnackBar(
        content: Text('Contraseña incorrecta. Inténtalo de nuevo.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

  void _forgotPassword() {
    // Agrega aquí la lógica para manejar "Olvidé mi contraseña".
  }

  void _goToRegistration() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: _forgotPassword,
                child: Text('Olvidé mi contraseña'),
              ),
              TextButton(
                onPressed: _goToRegistration,
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




