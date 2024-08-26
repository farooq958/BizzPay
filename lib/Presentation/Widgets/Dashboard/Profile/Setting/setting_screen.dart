import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Repository/ChangePassword/change_password.dart';
import 'package:buysellbiz/Data/DataSource/Repository/CustomerSupport/customer_support.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/User/user_model.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/BadgesRequests/badges_requests.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_list_tile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/YourBusinessList/your_business.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/add_card.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/change_password.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/customer_support.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/personal_information.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/terms_and_conditions.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: AppText(
            'Setting',
            style: Styles.circularStdBold(context,
                fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Column(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        CustomListTile(
                          title: AppStrings.personalLinfo,
                          leadingicon: Assets.profile,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, const PersonalInformation());
                          },
                        ),
                        CustomListTile(
                          title: AppStrings.ChangePass,
                          leadingicon: Assets.unlock,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, ChangePassword());
                          },
                        ),
                        CustomListTile(
                          title: AppStrings.referAfri,
                          leadingicon: Assets.share,
                          trailing: Assets.down,
                          onPressed: () async {
                            final encoded = Uri.encodeFull(
                                "https://bizzpayapp.com/download_app");
                            await Share.share(encoded);
                          },
                        ),

                        ///Privacy policy
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigate.to(context, PrivacyPolicy());
                        //   },
                        //   child: const CustomListTile(
                        //     title: AppStrings.privacyPol,
                        //     leadingicon: Assets.document,
                        //     trailing: Assets.down,
                        //   ),
                        // ),
                        CustomListTile(
                          title: AppStrings.termsAndcon,
                          leadingicon: Assets.paper,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, TermsAndConditions());
                          },
                        ),
                        CustomListTile(
                          title: "Customer Support",
                          leadingicon: Assets.call,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, CustomerSupport());
                          },
                        ),
                        CustomListTile(
                          title: "Add Card",
                          leadingicon: Assets.card,
                          trailing: Assets.down,
                          onPressed: () {
                            UserModel? userData = Data.app.user;

                            Navigate.to(
                                context,
                                StripeCardWidget(
                                  userModel: userData,
                                ));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
