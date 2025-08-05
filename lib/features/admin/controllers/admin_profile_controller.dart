import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/user_profile_model.dart';

class AdminProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  var isLoading = true.obs;
  var user = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final response = await apiService.get('/user/profile');
      if (response.statusCode == 200) {
        user.value = UserProfile.fromJson(response.body['data']);
      } else {
        Get.snackbar("Error", response.body['message'] ?? 'Gagal memuat data.');
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan saat memuat profil.");
    } finally {
      isLoading.value = false;
    }
  }
}
