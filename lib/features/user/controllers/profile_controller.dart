import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final profile = Rx<ProfileModel?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await apiService.getProfile();
      print('Profile fetch response: $response'); // Logging untuk debugging
      profile.value = ProfileModel.fromJson(response);
    } catch (e) {
      print('Profile fetch error: $e'); // Logging untuk debugging
      String message = e.toString();
      if (message.contains('401')) {
        message = 'Unauthorized. Please login again.';
      } else if (message.contains('429')) {
        message = 'Too many requests. Please try again later.';
      } else {
        message = 'Failed to load profile: $e';
      }
      errorMessage.value = message;
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await apiService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e'); // Logging
      Get.snackbar('Error', 'Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
