import 'package:buysellbiz/Application/Services/ApiServices/api_services.dart';
import 'package:buysellbiz/Data/AppData/data.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';

class DeleteCard {
  static Future<Map<String, dynamic>> deletePayment() async {
    return await ApiService.get(
      ApiConstant.removePaymentMethod,
      headers: {"Authorization": " ${Data.app.token}"},
    );
  }
}
