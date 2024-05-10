import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/auth_controller.dart';

class AccountSettingsScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
final userSingleton = UserSingleton();
  void _onSignOutClicked(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Borrar todos los datos del UserSingleton
                UserSingleton().token = '';
                UserSingleton().name = '';
                UserSingleton().username = '';
                UserSingleton().email = '';

                // Implementa la lógica para cerrar sesión
                _authController.changeTab(0); // Cambiar a la pestaña 0
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar Sesión',
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
  bool obscurePassword = true; // Estado para controlar si se muestra u oculta la contraseña

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Eliminar Cuenta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Introduce tu contraseña:'),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword; // Alternar entre mostrar y ocultar la contraseña
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
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Implementa la lógica para borrar la cuenta
                  String password = passwordController.text;
                  print('Contraseña introducida: $password');
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Eliminar Cuenta',
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
              title: Text('Cambiar Contraseña'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPasswordTextField(
                    controller: currentPasswordController,
                    hintText: 'Contraseña actual',
                    showPassword: showCurrentPassword,
                    togglePasswordVisibility: () {
                      setState(() {
                        showCurrentPassword = !showCurrentPassword;
                      });
                    },
                  ),
                  _buildPasswordTextField(
                    controller: newPasswordController,
                    hintText: 'Nueva contraseña',
                    showPassword: showNewPassword,
                    togglePasswordVisibility: () {
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                  ),
                  _buildPasswordTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar nueva contraseña',
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
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Implementa la lógica para cambiar la contraseña
                    String currentPassword = currentPasswordController.text;
                    String newPassword = newPasswordController.text;
                    String confirmPassword = confirmPasswordController.text;
                    print('Contraseña actual: $currentPassword');
                    print('Nueva contraseña: $newPassword');
                    print('Confirmar nueva contraseña: $confirmPassword');
                    Navigator.of(context).pop();
                  },
                  child: Text('Cambiar Contraseña'),
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
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar Correo Electrónico'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Nuevo correo electrónico',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Implementa la lógica para cambiar el correo electrónico
                String newEmail = emailController.text;
                print('Nuevo correo electrónico: $newEmail');
                Navigator.of(context).pop();
              },
              child: Text('Cambiar Correo Electrónico'),
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
        title: Text('Configuración de la Cuenta'),
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
                  _buildListTile('Cambiar Correo Electrónico', Icons.email, () => _onChangeEmailClicked(context)),
                  _buildListTile('Cambiar Contraseña', Icons.lock, () => _onChangePasswordClicked(context)),
                  _buildListTile('Cuentas Bloqueadas', Icons.block, null), // Cuenta bloqueada
                  _buildListTile('Cerrar Sesión', Icons.exit_to_app, () => _onSignOutClicked(context)),
                  _buildListTile('Eliminar Cuenta', Icons.delete, () => _onDeleteAccountClicked(context)),
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

  Widget _buildListTile(String title, IconData icon, Function()? onTap, {bool disabled = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: disabled ? Colors.grey : (title == 'Eliminar Cuenta' ? Colors.red : Colors.white), // Color rojo para "Eliminar Cuenta"
        ),
      ),
      leading: Icon(
        icon,
        color: disabled ? Colors.grey : (title == 'Eliminar Cuenta' ? Colors.red : Colors.white), // Color rojo para "Eliminar Cuenta"
      ),
      onTap: disabled ? null : onTap,
    );
  }
}
