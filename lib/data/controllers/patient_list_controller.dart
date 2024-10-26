import 'package:ayurveda/data/config/constants.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../config/dio.dart';

class PatientListController extends GetxController {
  Future<Map<String, dynamic>> fetchPatients() async {
    final dioInstance = DioInstance();

    var response = await dioInstance.dio.get(LIST_PATIENTS_API_URL);

    return response.data;
  }
}
