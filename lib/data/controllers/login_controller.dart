import 'package:ayurveda/data/config/constants.dart';
import 'package:ayurveda/data/config/dio.dart';
import 'package:dio/dio.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Future<Map<String, dynamic>> login(
      {required String username, required String password}) async {
    try {
      FormData formData =
          FormData.fromMap({"username": username, "password": password});

      final dioInstance = DioInstance();

      var response = await dioInstance.dio.post(LOGIN_API_URL, data: formData);

      if (response.data["status"]) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', response.data["token"]);
      }

      return response.data;
    } catch (e) {
      return {
        "status": false,
        "message": "Failed to login. Please try again after some time."
      };
    }
  }
}
