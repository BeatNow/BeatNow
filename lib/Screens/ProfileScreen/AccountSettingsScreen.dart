import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final AuthController _authController = Get.find<AuthController>();

class AccountSettingsScreen extends StatelessWidget {
  final userSingleton = UserSingleton();
  void _onSignOutClicked(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Borrar todos los datos del UserSingleton
                UserSingleton().token = '';
                UserSingleton().name = '';
                UserSingleton().username = '';
                UserSingleton().email = '';

                // Implementa la lógica para cerrar sesión
                _authController.changeTab(9); // Cambiar a la pestaña 0
                Navigator.of(context).pop();
              },
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.red), // Color rojo
              ),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteAccountClicked(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    bool obscurePassword =
        true; // Estado para controlar si se muestra u oculta la contraseña

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Delete account'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Enter your password:'),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword; // Alternar entre mostrar y ocultar la contraseña
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Implementa la lógica para borrar la cuenta

                    _authController.changeTab(0); // Cambiar a la pestaña 0

                    dropUser(passwordController.text);
                    Navigator.of(context).pop();
                    _authController.changeTab(0);
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red), // Color rojo
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onChangePasswordClicked(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    bool showCurrentPassword = false;
    bool showNewPassword = false;
    bool showConfirmPassword = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPasswordTextField(
                    controller: currentPasswordController,
                    hintText: 'Actual Password',
                    showPassword: showCurrentPassword,
                    togglePasswordVisibility: () {
                      setState(() {
                        showCurrentPassword = !showCurrentPassword;
                      });
                    },
                  ),
                  _buildPasswordTextField(
                    controller: newPasswordController,
                    hintText: 'New Password',
                    showPassword: showNewPassword,
                    togglePasswordVisibility: () {
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                  ),
                  _buildPasswordTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm new password',
                    showPassword: showConfirmPassword,
                    togglePasswordVisibility: () {
                      setState(() {
                        showConfirmPassword = !showConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Implementa la lógica para cambiar la contraseña
                    String currentPassword = currentPasswordController.text;
                    String newPassword = newPasswordController.text;
                    String confirmPassword = confirmPasswordController.text;
                    if (newPassword != confirmPassword) {
                      print('Passwords do not match');
                      return;
                    } else {
                      changePassword(UserSingleton().username, currentPassword,
                          newPassword);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Change Password'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String hintText,
    required bool showPassword,
    required Function togglePasswordVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            togglePasswordVisibility();
          },
        ),
      ),
    );
  }

  void _onChangeEmailClicked(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    bool obscurePassword =
        true; // Estado para controlar si se muestra u oculta la contraseña
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Change Email Adress'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'New Email Address',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword; // Alternar entre mostrar y ocultar la contraseña
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Implementa la lógica para cambiar el correo electrónico
                    String newEmail = emailController.text;
                    String password = passwordController.text;
                    updateEmail(newEmail, password);
                    Navigator.of(context).pop();
                  },
                  child: Text('Change Email Address'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _authController.changeTab(4);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212), // darker shade
              Color(0xFF0D0D0D), // even darker shade
            ],
            stops: [0.5, 1.0], // where to start and end each color
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildListTile('Change Email Adress', Icons.email,
                      () => _onChangeEmailClicked(context)),
                  _buildListTile('Change Password', Icons.lock,
                      () => _onChangePasswordClicked(context)),
                  _buildListTile('Blocked Accounts', Icons.block,
                      null), // Cuenta bloqueada
                  _buildListTile('Log Out', Icons.exit_to_app,
                      () => _onSignOutClicked(context)),
                  _buildListTile('Delete Account', Icons.delete,
                      () => _onDeleteAccountClicked(context)),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey, // Color de la línea divisoria
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '© BeatNow Development', // Marca registrada
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, Function()? onTap,
      {bool disabled = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: disabled
              ? Colors.grey
              : (title == 'Delete Account'
                  ? Colors.red
                  : Colors.white), // Color rojo para "Eliminar Cuenta"
        ),
      ),
      leading: Icon(
        icon,
        color: disabled
            ? Colors.grey
            : (title == 'Delete Account'
                ? Colors.red
                : Colors.white), // Color rojo para "Eliminar Cuenta"
      ),
      onTap: disabled ? null : onTap,
    );
  }
}

// Implementar api  de update users
Future<Map<String, dynamic>?> updateEmail(String email, String password) async {
  final apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/update');
  Map<String, dynamic> body = {
    'full_name': UserSingleton().name,
    'email': email,
    'username': UserSingleton().username,
    'password': password,
    'bio': '',
    '_id': UserSingleton().id
  };
  String token = UserSingleton()
      .token; // Asegúrate de tener el token disponible en UserSingleton

  try {
    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      // La solicitud se realizó correctamente
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        // El cuerpo de la respuesta está vacío, devolver un mapa vacío
        return {"message": "failed"};
      }
    } else if (response.statusCode == 401) {
      // La autorización falló
      print('Error: Unauthorized request');
      return null;
    } else {
      // Otros errores de la solicitud
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    // Mostrar mensaje de error si se produce una excepción
    print('Error: $e');
    return null;
  }
}

// Implementar api de delete users
Future<Map<String, dynamic>?> deleteUser() async {
  final apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/delete');
  
  String token = UserSingleton().token;
  try {
    final response = await http.delete(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.body.isNotEmpty) {
      UserSingleton().id = "";
      UserSingleton().name = "";
      UserSingleton().username = "";
      UserSingleton().email = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('username');
      prefs.remove('password');

      return null;
    } else if (response.statusCode == 401) {
      // Mostrar mensaje de error si la solicitud falla
      print('Request failed with status: ${response.statusCode}.');
      return null;
    } else {
      // Mostrar mensaje de error si la solicitud falla
      print('Request failed with status: ${response.statusCode}.');
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    // Mostrar mensaje de error si se produce una excepción
    print('Error: $e');
    return null;
  }
}

// Implementar api de change password
Future<Map<String, dynamic>?> updatePassword(String newPassword) async {
  final apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/update');
  Map<String, dynamic> body = {
    'full_name': UserSingleton().name,
    'email': UserSingleton().email,
    'username': UserSingleton().username,
    'password': newPassword,
    'bio': '',
    '_id': UserSingleton().id
  };
  String token = UserSingleton()
      .token; // Asegúrate de tener el token disponible en UserSingleton

  try {
    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      // La solicitud se realizó correctamente
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        // El cuerpo de la respuesta está vacío, devolver un mapa vacío
        return {"message": "failed"};
      }
    } else if (response.statusCode == 401) {
      // La autorización falló
      print('Error: Unauthorized request');
      return null;
    } else {
      // Otros errores de la solicitud
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    // Mostrar mensaje de error si se produce una excepción
    print('Error: $e');
    return null;
  }
}

Future<Map<String, dynamic>> changePassword(
    String username, String password, String newPassword) async {
  final apiUrl = Uri.parse('http://217.182.70.161:6969/token');

  final body = {
    'username': username,
    'password': password,
  };

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    updatePassword(newPassword);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get token');
  }
}

Future<Map<String, dynamic>> dropUser(String password) async {
  final apiUrl = Uri.parse('http://217.182.70.161:6969/token');

  final body = {
    'username': UserSingleton().username,
    'password': password,
  };

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    deleteUser();
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get token');
  }
}
