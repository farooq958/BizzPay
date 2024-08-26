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

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: AppText(
            'Seller Dashboard',
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
                          title: 'Seller Request',
                          leadingicon: Assets.businessDash,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, const BadgesRequestScreen());
                          },
                        ),
                        CustomListTile(
                          title: "Listings",
                          leadingicon: Assets.plus,
                          trailing: Assets.down,
                          onPressed: () {
                            Navigate.to(context, const YourBusiness());
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
