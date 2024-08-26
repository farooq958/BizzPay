import 'package:buysellbiz/Application/Services/ApiServices/api_services.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';

class ForgetEmail {
  static Future<Map<String, dynamic>> forgetEmail(
      {required String email, bool? isFromOtpScreen}) async {
    try {
      String apiUrl = isFromOtpScreen == true
          ? ApiConstant.resendOtp
          : ApiConstant.forgetEmail;

      return await ApiService.get("$apiUrl/$email").then((value) {
        return value;
      }).catchError((e) {
        throw e;
      });
    } catch (e) {
      rethrow;
    }
  }
}
