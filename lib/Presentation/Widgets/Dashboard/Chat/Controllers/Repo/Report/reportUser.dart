import 'dart:developer';

import 'package:buysellbiz/Application/Services/ApiServices/api_services.dart';
import 'package:buysellbiz/Data/AppData/data.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';

class ReportUserRepo {
  Future<Map<String, dynamic>> reportUser(
      {required Map<String, dynamic> body, String? userId}) async {
    var headers = {"authorization": " ${Data.app.token}"};

    try {
      print("base url ${ApiConstant.reportUser}");
      return await ApiService.post("${ApiConstant.reportUser}/$userId", body,
              header: headers)
          .then((value) {
        log("here is log $value");
        return value;
      }).catchError((e) {
        throw e;
      });
    } catch (e) {
      rethrow;
    }
  }
}
