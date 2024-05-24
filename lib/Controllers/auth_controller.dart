import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var selectedIndex = 0.obs;
  var isLoading = true.obs;

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
    if (token != null) {
      final userInfo = await getUserInfo(token);
      if (userInfo != null) {
        selectedIndex.value = 3;
        isLoading.value = false;
      } else {
        selectedIndex.value = 9;
        isLoading.value = false;
      }
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
        return jsonResponse;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
