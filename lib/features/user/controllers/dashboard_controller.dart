import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../models/home_summary_model.dart';
import '../../authentication/models/user_model.dart';

class DashboardController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final GetStorage storage = GetStorage();
  final summary = Rx<HomeSummaryModel?>(null);
  final userName = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    fetchUserName();
    fetchHomeSummary();
    super.onInit();
  }

  void fetchUserName() {
    final userJson = storage.read('user');
    if (userJson != null) {
      final user = UserModel.fromJson(userJson);
      userName.value = user.name;
      print('User name fetched: ${user.name}');
    } else {
      userName.value = 'User';
      print('No user data found in storage');
    }
  }

  Future<void> fetchHomeSummary() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await apiService.getHomeSummary();
      summary.value = HomeSummaryModel.fromJson(response);
    } catch (e) {
      print('Home summary error: $e');
      String message = e.toString();
      if (message.contains('401')) {
        message = 'Unauthorized. Please login again.';
      } else if (message.contains('429')) {
        message = 'Too many requests. Please try again later.';
      } else {
        message = 'Failed to load dashboard: $e';
      }
      errorMessage.value = message;
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }
}
