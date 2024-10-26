import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/controllers/register_controller.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List<Map<String, dynamic>> locations = [
    {"id": "1", "name": 'Location 1'},
    {"id": "2", "name": 'Location 1'},
    {"id": "3", "name": 'Location 1'}
  ];

  final List<String> treatments = ['Treatment 1', 'Treatment 2', 'Treatment 3'];

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView(
            children: [
              _buildLabelTextField(
                  'Name', 'Enter your full name', controller.nameController),
              const SizedBox(height: 15),
              _buildLabelTextField('WhatsApp Number',
                  'Enter your WhatsApp number', controller.whatsappController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 15),
              _buildLabelTextField('Address', 'Enter your address',
                  controller.addressController),
              const SizedBox(height: 15),
              _buildLabelDropdown(
                  'Location', locations, controller.selectedLocation.value,
                  (value) {
                controller.selectedLocation.value = value ?? "";
              }),
              const SizedBox(height: 15),
              _buildLabelDropdown('Branch', controller.branches,
                  controller.selectedBranch.value, (value) {
                controller.selectedBranch.value = value ?? "";
              }),
              const SizedBox(height: 15),
              const Text(
                'Select Treatment:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Container(
                color: const Color.fromARGB(255, 111, 188, 130),
                child: ElevatedButton(
                  onPressed: () {
                    _showTreatmentDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 111, 188, 130),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        controller.selectedTreatment?.value ?? 'Add Treatment',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildLabelTextField('Total Amount', 'Enter total amount',
                  controller.totalAmountController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildLabelTextField('Discount Amount', 'Enter discount amount',
                  controller.discountAmountController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildPaymentOptions(controller),
              const SizedBox(height: 15),
              _buildLabelTextField('Advance Amount', 'Enter advance amount',
                  controller.advanceAmountController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildLabelTextField('Balance Amount', 'Enter balance amount',
                  controller.balanceAmountController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              const Text(
                'Treatment Date:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              _buildDateSelector(controller),
              const SizedBox(height: 15),
              const Text(
                'Treatment Time:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              _buildTimeDropdowns(controller),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var res = await controller.registerPatient();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res["message"])),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF006837),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLabelTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildLabelDropdown(String label, List items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue == "" ? null : selectedValue,
          hint: Text('Select $label'),
          items: items.isEmpty
              ? null
              : items.map((item) {
                  return DropdownMenuItem(
                    value: item["id"].toString(),
                    child: Text(item["name"] as String),
                  );
                }).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions(RegisterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Type:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: 'cash',
                  groupValue: controller.paymentType.value,
                  onChanged: (value) {
                    controller.paymentType.value = value!;
                  },
                ),
                const Text('Cash'),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'card',
                  groupValue: controller.paymentType.value,
                  onChanged: (value) {
                    controller.paymentType.value = value!;
                  },
                ),
                const Text('Card'),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'upi',
                  groupValue: controller.paymentType.value,
                  onChanged: (value) {
                    controller.paymentType.value = value!;
                  },
                ),
                const Text('UPI'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeDropdowns(RegisterController controller) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            hint: const Text('Hour'),
            items: List.generate(24, (index) => index).map((hour) {
              return DropdownMenuItem(
                value: hour,
                child: SizedBox(
                  height: 15,
                  child: Center(child: Text(hour.toString().padLeft(2, '0'))),
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller.treatmentTimeHour.value = value.toString();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: DropdownButtonFormField<int>(
            hint: const Text('Minute'),
            items: List.generate(60, (index) => index).map((minute) {
              return DropdownMenuItem(
                value: minute,
                child: SizedBox(
                  height: 20,
                  child: Center(child: Text(minute.toString().padLeft(2, '0'))),
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller.treatmentTimeMinute.value = value.toString();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(RegisterController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.selectedDate.value = pickedDate;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.selectedDate.value.year == 9999
                  ? 'Select Date'
                  : '${controller.selectedDate.value.day}-${controller.selectedDate.value.month}-${controller.selectedDate.value.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Future<void> _showTreatmentDialog() async {
    String? selectedTreatment;
    int maleCount = 0;
    int femaleCount = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Treatment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Choose Treatment'),
                    value: selectedTreatment,
                    items: treatments.map((treatment) {
                      return DropdownMenuItem(
                        value: treatment,
                        child: Text(treatment),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTreatment = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Text(
                  'Add Patients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGenderCounter('Male', maleCount, (count) {
                      setState(() {
                        maleCount = count;
                      });
                    }),
                    _buildGenderCounter('Female', femaleCount, (count) {
                      setState(() {
                        femaleCount = count;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006837),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderCounter(
      String gender, int count, ValueChanged<int> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: Text(gender),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF006837),
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                onPressed: () {
                  if (count > 0) onChanged(count - 1);
                },
                icon: const Icon(Icons.remove, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text('$count', style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF006837),
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                onPressed: () {
                  onChanged(count + 1);
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
