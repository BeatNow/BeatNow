import 'dart:convert';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:BeatNow/Controllers/auth_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
 
class CodeConfirmationScreen extends StatefulWidget {
  @override
  _CodeConfirmationScreenState createState() => _CodeConfirmationScreenState();
}
 
class _CodeConfirmationScreenState extends State<CodeConfirmationScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _codeController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF3C0F4B),
      minimumSize: Size(double.infinity, 56),
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      textStyle: TextStyle(
        fontFamily: 'Franklin Gothic Demi',
        fontSize: 16.0,
      ),
    );
 
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Color(0xFF111111),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _authController.changeTab(9);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Enter Confirmation Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Franklin Gothic Demi'),
                ),
                SizedBox(height: 20.0),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _codeController,
                  autoDismissKeyboard: true,
                  autoDisposeControllers: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12.0),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Color(0xFF494949),
                    inactiveFillColor: Color(0xFF494949),
                    selectedFillColor: Color(0xFF494949),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white70,
                    selectedColor: Colors.white,
                  ),
                  backgroundColor: Color(0xFF111111),
                  textStyle: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {},
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    _submitCode(_codeController.text, context);
                  },
                  style: buttonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  void _submitCode(String code, BuildContext context) async {
    final token = UserSingleton().token;
 
    if (token != null) {
      final response = await _sendCodeToApi(token, code);
 
      if (response['message'] == 'Ok') {
        _authController.changeTab(3);
      } else {
        _showErrorSnackBar('Invalid code', context);
      }
    } else {
      _showErrorSnackBar('User not found', context);
    }
  }
 
  Future<Map<String, dynamic>> _sendCodeToApi(String token, String code) async {
    final apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/mail/confirmation/?code=$code');
 
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: '',
      );
 
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Error'};
      }
    } catch (e) {
      print('Error: $e');
      return {'message': 'Error'};
    }
  }
 
  void _showErrorSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3C0F4B),
      ),
    );
  }
}