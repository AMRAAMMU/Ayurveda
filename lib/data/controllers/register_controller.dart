import 'package:ayurveda/data/config/constants.dart';
import 'package:ayurveda/data/config/dio.dart';
import 'package:ayurveda/data/controllers/patient_list_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var branches = [].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();

  Rx<DateTime> selectedDate = DateTime(9999).obs;
  RxString selectedBranch = "".obs;
  RxString selectedLocation = "1".obs;
  RxString paymentOption = 'advance'.obs;
  RxString? selectedTreatment;
  RxString paymentType = 'cash'.obs;
  RxString treatmentTimeHour = "00".obs;
  RxString treatmentTimeMinute = "00".obs;

  @override
  void onInit() async {
    super.onInit();

    branches.value = await _fetchBranches();
  }

  Future<List> _fetchBranches() async {
    final dioInstance = DioInstance();

    var response = await dioInstance.dio.get(LIST_BRANCHES_API_URL);

    return response.data["branches"];
  }

  Future<Map<String, dynamic>> registerPatient() async {
    try {
      if (selectedDate.value.year == 9999) {
        return {"status": false, "message": "Date is required"};
      }

      if (double.tryParse(totalAmountController.text) == null) {
        return {"status": false, "message": "Invalid total amount"};
      }

      if (double.tryParse(discountAmountController.text) == null) {
        return {"status": false, "message": "Invalid discount amount"};
      }

      if (double.tryParse(advanceAmountController.text) == null) {
        return {"status": false, "message": "Invalid advance amount"};
      }

      if (double.tryParse(balanceAmountController.text) == null) {
        return {"status": false, "message": "Invalid balance amount"};
      }

      String treatmentDate =
          "${selectedDate.value.toString().split('00:')[0]}T$treatmentTimeHour:$treatmentTimeMinute:00";

      dio.FormData formData = dio.FormData.fromMap({
        "id": "",
        "name": nameController.text,
        "excecutive": "",
        "payment": paymentType.value,
        "phone": whatsappController.text,
        "address": addressController.text,
        "total_amount": totalAmountController.text,
        "discount_amount": discountAmountController.text,
        "advance_amount": advanceAmountController.text,
        "balance_amount": balanceAmountController.text,
        "date_nd_time": treatmentDate,
        "branch": selectedBranch.value,
        "male": "100,90",
        "female": "100,90",
        "treatments": "100,90"
      });

      final dioInstance = DioInstance();

      var response =
          await dioInstance.dio.post(REGISTER_PATIENT_API_URL, data: formData);

      if (response.data["status"]) {
        nameController.clear();
        whatsappController.clear();
        addressController.clear();
        totalAmountController.clear();
        discountAmountController.clear();
        advanceAmountController.clear();
        balanceAmountController.clear();

        selectedDate.value = DateTime(9999);
        selectedBranch.value = "";
        selectedLocation.value = "1";
        paymentOption.value = 'advance';
        paymentType.value = 'cash';
        treatmentTimeHour.value = "00";
        treatmentTimeMinute.value = "00";

        final controller = Get.find<PatientListController>();

        controller.fetchPatients();

        Get.toNamed("/patient-list");
      }

      return response.data;
    } catch (e) {
      return {
        "status": false,
        "message": "Failed to register. Please try again."
      };
    }
  }
}
