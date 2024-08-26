import 'dart:developer';

import 'package:buysellbiz/Application/Services/ApiServices/api_services.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';

class CustomerSupportRepo {
  static Future addIssueTOSupport(
      {Map<String, dynamic>? body, List<String?>? images}) async {
    return await ApiService.postMultipart(
            ApiConstant.customerSupport, body!, images!,
            imagePathName: 'files')
        .then((value) {
      log(value.toString());

      return value;
    });
  }
}
