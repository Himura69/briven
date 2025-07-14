import 'package:get/get.dart';
import '../models/loan_history_model.dart';
import '../../../services/api_service.dart';

class LoanHistoryController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final loanHistory = <LoanHistoryModel>[].obs;
  final meta = Rxn<LoanHistoryMeta>();
  final currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoanHistory();
  }

  Future<void> fetchLoanHistory({int page = 1, int perPage = 10}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('Mengambil riwayat peminjaman untuk page=$page, perPage=$perPage');
      final response =
          await apiService.getLoanHistory(page: page, perPage: perPage);
      print('Respons riwayat peminjaman mentah: ${response.toString()}');
      final data = response['data'] as List<dynamic>? ?? [];
      final metaData = response['meta'] as Map<String, dynamic>? ??
          {'currentPage': 1, 'lastPage': 1, 'total': 0};
      print('Parsing loan history JSON: $data');
      print('Parsing meta JSON: $metaData');
      loanHistory.value = data
          .map(
              (item) => LoanHistoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
      meta.value = LoanHistoryMeta.fromJson(metaData);
      currentPage.value = meta.value?.currentPage ?? 1;
      print(
          'Riwayat peminjaman yang dipetakan: ${loanHistory.map((e) => e.toJson())}');
      print('Meta paginasi: ${meta.value?.toJson()}');
    } catch (e) {
      print('Error mengambil riwayat peminjaman: $e');
      errorMessage.value =
          e.toString().contains('Token autentikasi tidak ditemukan')
              ? 'Sesi Anda telah berakhir. Silakan login kembali.'
              : 'Gagal memuat riwayat peminjaman: $e';
      loanHistory.clear();
      meta.value = null;
      currentPage.value = 1;
    } finally {
      isLoading.value = false;
    }
  }

  void goToPreviousPage() {
    print('Memanggil goToPreviousPage, currentPage: ${currentPage.value}');
    if (currentPage.value > 1) {
      fetchLoanHistory(page: currentPage.value - 1);
    } else {
      print('Tidak bisa ke halaman sebelumnya: sudah di halaman 1');
    }
  }

  void goToNextPage() {
    print(
        'Memanggil goToNextPage, currentPage: ${currentPage.value}, lastPage: ${meta.value?.lastPage}');
    if (meta.value != null && currentPage.value < meta.value!.lastPage) {
      fetchLoanHistory(page: currentPage.value + 1);
    } else {
      print(
          'Tidak bisa ke halaman berikutnya: meta=${meta.value?.toJson()}, currentPage=${currentPage.value}');
    }
  }
}
