import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalController extends GetxController {
  Future<bool> checkUserAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    return token != null;
  }
}
