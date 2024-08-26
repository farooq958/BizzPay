import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/AppData/app_preferences.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Widgets/Auth/Login/login_onboard.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Controller/delete_check_controller.dart';
import 'package:buysellbiz/Presentation/Widgets/Onboarding/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeleteWebView extends StatefulWidget {
  const DeleteWebView({super.key});

  @override
  State<DeleteWebView> createState() => _DeleteWebViewState();
}

class _DeleteWebViewState extends State<DeleteWebView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop)async {
print(didPop);

await DeleteCheckController().getDeleteCheck();

      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(
          ),

          //title: const Text('Delete Account'),
        ),
        body: WebView(
          onPageFinished: (url) {

            //SharedPrefs.clearUserData().then((value) {});
          },
          initialUrl: 'http://bizzpayapp.com/login',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
