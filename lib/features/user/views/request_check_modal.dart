import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class RequestCheckModal extends StatelessWidget {
  final String deviceId;

  const RequestCheckModal({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final modalWidth = isWeb ? screenWidth * 0.4 : screenWidth * 0.8;

    // Variabel untuk date picker
    final selectedDate = DateTime.now().obs;
    final descriptionController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: modalWidth),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 24.0 : 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request Device Check',
                style: AppStyles.title.copyWith(
                  fontSize: isWeb ? 20 : 18,
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker
              Obx(
                () => TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      selectedDate.value = pickedDate;
                    }
                  },
                  child: Text(
                    'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate.value)}',
                    style: AppStyles.body.copyWith(
                      fontSize: isWeb ? 16 : 14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Textarea untuk Deskripsi
              CustomTextField(
                hintText: 'Enter description (e.g., reason for check)',
                controller: descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              // Tombol Submit dan Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      Get.back();
                    },
                    width: isWeb ? modalWidth * 0.45 : modalWidth * 0.4,
                  ),
                  CustomButton(
                    text: 'Submit',
                    onPressed: () {
                      // Logika submit akan ditambahkan nanti
                      Get.snackbar(
                          'Success', 'Request submitted for device $deviceId');
                      Get.back();
                    },
                    width: isWeb ? modalWidth * 0.45 : modalWidth * 0.4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
