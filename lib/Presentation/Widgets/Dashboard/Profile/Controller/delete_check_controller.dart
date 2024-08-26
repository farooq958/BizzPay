import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/AppData/app_preferences.dart';
import 'package:buysellbiz/Data/DataSource/Repository/DeleteCheckRepo/delete_check_repo.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Widgets/Auth/Login/login.dart';
import 'package:buysellbiz/Presentation/Widgets/Auth/Login/login_onboard.dart';

class DeleteCheckController{


  ValueNotifier<int> deleteCheck = ValueNotifier<int>(0);

  getDeleteCheck() async {
   await DeleteCheckRepo().checkDelete().then((value) async {
deleteCheck.value=1;
     print("delete value ");
      print(value);
if(value['Success']==false)
{
  deleteCheck.value=3;
  if (value['body'] != null)
  {}
  else
  {

  //  WidgetFunctions.instance.snackBar(Data.app.navigatorKey.currentContext!,text: 'User not found or User  have been Deleted');

    await SharedPrefs.clearUserData();
    Navigate.toReplaceAll(Data.app.navigatorKey.currentContext!,const LoginOnboard());
  }
}

if(value['Success']) {



}
else if(value['StatusCode']!=null && value['StatusCode']==401)
  {

  //  WidgetFunctions.instance.snackBar(Data.app.navigatorKey.currentContext!,text: 'User not found or User  have been Deleted');

    await SharedPrefs.clearUserData();
    Navigate.toReplaceAll(Data.app.navigatorKey.currentContext!,const LoginOnboard());

  }
else
  {


    deleteCheck.value=3;
  }

   }).catchError((e) {
      print(e);
      deleteCheck.value=3;
    });
  }

}