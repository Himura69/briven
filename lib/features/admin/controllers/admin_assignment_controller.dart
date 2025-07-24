import 'package:briven/features/admin/models/admin_assignment_detail_model.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/admin_assignment_model.dart';

class AdminAssignmentsController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  var assignments = <AdminAssignmentModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isDetailLoading = false.obs;
  var detailError = ''.obs;
  var assignmentDetail = Rxn<AdminAssignmentDetailModel>();

  var currentPage = 1.obs;
  var lastPage = 1.obs;

  var searchQuery = ''.obs;
  var activeOnly = false.obs;

  Future<void> fetchAssignments({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await api.getAdminAssignments(
        search: searchQuery.value,
        activeOnly: activeOnly.value,
        page: page,
      );

      final List<dynamic> list = data['data'] ?? [];
      assignments.value =
          list.map((e) => AdminAssignmentModel.fromJson(e)).toList();

      final meta = data['meta'] ?? {};
      currentPage.value = meta['currentPage'] ?? 1;
      lastPage.value = meta['lastPage'] ?? 1;
    } catch (e) {
      errorMessage.value = 'Gagal memuat assignments: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAssignmentDetail(int id) async {
    try {
      isDetailLoading.value = true;
      detailError.value = '';
      assignmentDetail.value = null;

      final data = await api.getAdminAssignmentDetail(id);
      assignmentDetail.value = AdminAssignmentDetailModel.fromJson(data);
    } catch (e) {
      detailError.value = 'Gagal memuat detail: $e';
    } finally {
      isDetailLoading.value = false;
    }
  }

  void toggleActiveOnly() {
    activeOnly.value = !activeOnly.value;
    fetchAssignments();
  }

  Future<void> refreshAssignments() async {
    await fetchAssignments(page: 1);
  }
}
