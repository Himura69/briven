import 'package:briven/features/admin/models/admin_assignment_detail_model.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/admin_assignment_model.dart';

class AdminAssignmentsController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  // Data utama untuk list
  var assignments = <AdminAssignmentModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Data untuk detail
  var isDetailLoading = false.obs;
  var detailError = ''.obs;
  var assignmentDetail = Rxn<AdminAssignmentDetailModel>();

  // Pagination & Filter
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var searchQuery = ''.obs;
  var activeOnly = false.obs;

  // Untuk Form
  var formOptions = <String, dynamic>{}.obs;
  var validationRules = <String, dynamic>{}.obs;
  var isFormLoading = false.obs;
  var formError = ''.obs;

  /// Fetch daftar assignments
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

  /// Ambil detail assignment
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

  /// Ambil semua data dropdown & opsi untuk form assignment
  Future<void> loadFormOptions() async {
    try {
      isFormLoading.value = true;
      formError.value = '';
      final data = await api.getAssignmentFormOptions();
      formOptions.value = data;
    } catch (e) {
      formError.value = 'Gagal memuat form options: $e';
    } finally {
      isFormLoading.value = false;
    }
  }

  /// Ambil rules validasi form assignment
  Future<void> loadValidationRules() async {
    try {
      final data = await api.getAssignmentValidationRules();
      validationRules.value = data;
    } catch (e) {
      formError.value = 'Gagal memuat validation rules: $e';
    }
  }

  /// Toggle filter activeOnly
  void toggleActiveOnly() {
    activeOnly.value = !activeOnly.value;
    fetchAssignments();
  }

  /// Refresh (misalnya swipe down)
  Future<void> refreshAssignments() async {
    await fetchAssignments(page: 1);
  }

  /// CRUD
  Future<Map<String, dynamic>> createAssignmentMultipart(
    Map<String, dynamic> payload) async {
  try {
    isLoading.value = true;
    errorMessage.value = '';
    final data = await api.createAdminAssignmentMultipart(payload);
    await fetchAssignments(); // refresh list setelah create
    return data;
  } catch (e) {
    errorMessage.value = e.toString();
    rethrow;
  } finally {
    isLoading.value = false;
  }
}

Future<Map<String, dynamic>> updateAssignmentMultipart(
    int id, Map<String, dynamic> payload) async {
  try {
    isLoading.value = true;
    errorMessage.value = '';
    final data = await api.updateAdminAssignmentMultipart(id, payload);
    await fetchAssignments(); // refresh list setelah update
    return data;
  } catch (e) {
    errorMessage.value = e.toString();
    rethrow;
  } finally {
    isLoading.value = false;
  }
}

}
