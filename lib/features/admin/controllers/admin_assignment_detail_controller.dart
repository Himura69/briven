import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/admin_assignment_detail_model.dart';

class AdminAssignmentDetailController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var assignmentDetail = Rxn<AdminAssignmentDetailModel>();

  /// Ambil detail assignment berdasarkan ID
  Future<void> fetchAssignmentDetail(int assignmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
          await apiService.getAdminAssignmentDetail(assignmentId);
      assignmentDetail.value =
          AdminAssignmentDetailModel.fromJson(response);
    } catch (e) {
      errorMessage.value = 'Gagal memuat detail assignment: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
