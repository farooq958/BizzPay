import 'package:buysellbiz/Application/Services/ApiServices/api_services.dart';
import 'package:buysellbiz/Data/AppData/data.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';

class DeleteCheckRepo {


  checkDelete() async {

    var headers = {"authorization": " ${Data.app.token}"};
    return await ApiService.get(ApiConstant.getUserById,headers: headers);

  }
}