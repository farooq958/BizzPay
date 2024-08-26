import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Application/Services/PaymentServices/payment_services.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/User/user_model.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/dialog.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/AllBadges/all_badges_screen.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_list_tile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/logout_dialog.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExpertProfile/export_profile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Requests/request_screen.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/expert_dashboard.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/BadgesRequests/badges_requests.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/SellerDashboard/seller_dashboard_screen.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Setting/setting_screen.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/add_card.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/change_password.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/customer_support.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/personal_information.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/terms_and_conditions.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/YourBusinessList/your_business.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Column(
              children: [
                40.y,
                Data.app.user?.user?.profilePic != null
                    ? CachedImage(
                        isFromProfilePic: true,
                        radius: 55.sp,
                        url: Data.app.user!.user!.profilePic!.contains('https')
                            ? "${Data.app.user?.user!.profilePic}"
                            : "${ApiConstant.baseurl}${Data.app.user?.user!.profilePic}")
                    : CachedImage(
                        radius: 55.sp,
                        url:
                            "http://18.118.10.44:8000//assets/user_profile.png"),
                Column(
                  children: [
                    10.y,
                    Text(
                      Data.app.user?.user?.fullName ?? "",
                      style: Styles.circularStdBold(context, fontSize: 20.sp),
                    ),
                    20.y,
                    Column(
                      children: [
                        CustomListTile(
                          title: "Setting",
                          leadingicon: Assets.setting,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, const SettingScreen());
                          },
                        ),
                        CustomListTile(
                          title: 'Buyer Badges',
                          leadingicon: Assets.appBadges,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(
                                context,
                                const AllBBadgesScreen(
                                  type: 'buyer',
                                ));
                          },
                        ),
                        CustomListTile(
                          title: 'Expert Dashboard',
                          leadingicon: Assets.expertDash,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, const ExpertDashboard());
                          },
                        ),
                        CustomListTile(
                          title: 'Seller Dashboard',
                          leadingicon: Assets.businessDash,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, const SellerDashboardScreen());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                50.y,
                CustomButton(
                  gapWidth: 7.w,
                  imageHeight: 20.h,
                  imageWidth: 20.w,
                  leadingIcon: Assets.logout,
                  leadingSvgIcon: true,
                  width: 230.w,
                  borderRadius: 40.r,
                  onTap: () {
                    CustomDialog.dialog(
                        barrierDismissible: true,
                        context,
                        const LogoutDialog());
                  },
                  text: AppStrings.logout,
                  bgColor: AppColors.whiteColor,
                  textFontWeight: FontWeight.w700,
                  textSize: 16.sp,
                  textColor: AppColors.greyMedium,
                ),
                20.y,
                AppText('Version 1.1.02',
                    style: Styles.circularStdRegular(context,
                        fontSize: 12.sp, color: AppColors.greyColor)),
                30.y,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
