import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class AuthController extends GetxController {
  var selectedIndex = 0.obs;
  var isLoading = true.obs;
  var email = ''.obs;
 
  @override
  void onInit() {
    super.onInit();
  }
 
  void changeTab(int index) {
    selectedIndex.value = index;
  }
 
 
  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') != null) {
      _login(prefs.getString('username') ?? '', prefs.getString('password') ?? '');
    } else {
      selectedIndex.value = 9;
      isLoading.value = false;
    }
    isLoading.value = false;
  }
 
  void _login(String username, String password) async {
    final token = await _token(username, password);
    final AuthController _authController = Get.find<AuthController>();
    if (token != null) {
      final userInfo = await getUserInfo(token);
      if (userInfo != null && userInfo['is_active'] == false) {
        _authController.changeTab(10);
    } else if(userInfo != null && userInfo['is_active'] == false){
        _authController.changeTab(3);
    } else {
        _authController.changeTab(9);
      }
    } else {
      _authController.changeTab(9);
    }
  }
 
  Future<Map<String, dynamic>> getTokenUser(String username, String password) async {
    final apiUrl = Uri.parse('http://217.182.70.161:6969/token');
    final body = {'username': username, 'password': password};
    final response = await http.post(apiUrl, headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: body);
    return json.decode(response.body);
  }
 
  Future<String?> _token(String username, String password) async {
    final response = await getTokenUser(username, password);
    if (response["access_token"] != null) {
      UserSingleton().token = response["access_token"];
      return response["access_token"];
    } else {
      return null;
    }
  }
 
  Future<Map<String, dynamic>?> getUserInfo(String token) async {
    final apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/users/me');
    try {
      final response = await http.get(apiUrl, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
      if (response.body.isNotEmpty) {
        final jsonResponse = jsonDecode(response.body);
        UserSingleton().id = jsonResponse['id'];
        UserSingleton().name = jsonResponse['full_name'];
        UserSingleton().username = jsonResponse['username'];
        UserSingleton().email = jsonResponse['email'];
        UserSingleton().isActive = jsonResponse['is_active'];
        return jsonResponse;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  void sendPasswordMail(String email) async {
    final AuthController _authController = Get.find<AuthController>();
    final response = await resetPassword(email);
    if (response != null) {
      Get.snackbar('Success', 'Email sent successfully');
      _authController.changeTab(9);
    } else {
      Get.snackbar('Error', 'Email not sent');
      _authController.changeTab(2);
    }
  }
  Future<Map<String, dynamic>?> resetPassword(String email) async {
  final apiUrl = Uri.parse('http://127.0.0.1:8000/v1/api/mail/send-password-reset/?mail=$email');
  try {
    final response = await http.post(
      apiUrl,
      headers: {'accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
 
}