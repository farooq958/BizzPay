import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/AllBadges/Controller/all_badges_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Home/Controller/Brokers/broker_by_id_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_appbar.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_list_tile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExpertProfile/export_profile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Controller/expert_dashboard_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Controller/expert_dashboard_state.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/LinkBank/link_bank_screen.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Requests/request_screen.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Withdraw/withdraw_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpertDashboard extends StatefulWidget {
  const ExpertDashboard({super.key});

  @override
  State<ExpertDashboard> createState() => _ExpertDashboardState();
}

class _ExpertDashboardState extends State<ExpertDashboard> {
  bool alreadyExist = false;
  bool isActive = true;
  @override
  void initState() {
    context.read<ExpertDashboardCubit>().getExpert();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Expert Dashboard',
        leading: true,
      ),
      body: BlocConsumer<ExpertDashboardCubit, ExpertDashboardState>(
        builder: (BuildContext context, state) => (state
                    is ErrorExpertDashboardState ||
                state is LoadingExpertDashboardState)
            ? const SizedBox.shrink()
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                children: [
                  if (alreadyExist)
                    ListTile(
                      onTap: () {
                        _pauseExpertProfile(context);
                      },
                      title: AppText(
                        isActive
                            ? 'Pause expert profile'
                            : 'Enable expert profile',
                        style: Styles.circularStdRegular(context, fontSize: 18),
                      ),
                      leading: Icon(Icons.history_toggle_off, size: 24.sp),
                      trailing:
                          Icon(Icons.arrow_forward_ios_sharp, size: 12.sp),
                    ),
                  if (alreadyExist) 10.y,
                  if (alreadyExist)
                    ListTile(
                      onTap: () {
                        _cancelSubscription(context);
                      },
                      title: AppText(
                        'Cancel subscription',
                        style: Styles.circularStdRegular(context, fontSize: 18),
                      ),
                      leading: Icon(Icons.cancel_presentation, size: 24.sp),
                      trailing:
                          Icon(Icons.arrow_forward_ios_sharp, size: 12.sp),
                    ),
                  if (alreadyExist) 10.y,
                  if (alreadyExist)
                    ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const RequestsScreen();
                          },
                        ));
                      },
                      title: AppText(
                        'Requests',
                        style: Styles.circularStdRegular(context, fontSize: 18),
                      ),
                      leading: Icon(Icons.upcoming, size: 24.sp),
                      trailing:
                          Icon(Icons.arrow_forward_ios_sharp, size: 12.sp),
                    ),
                  if (alreadyExist) 10.y,
                  if (alreadyExist)
                    ListTile(
                      onTap: () {
                        Navigate.to(context, const WithdrawScreen());
                      },
                      title: AppText(
                        'Withdraw',
                        style: Styles.circularStdRegular(context, fontSize: 18),
                      ),
                      leading: Icon(Icons.monetization_on, size: 24.sp),
                      trailing:
                          Icon(Icons.arrow_forward_ios_sharp, size: 12.sp),
                    ),
                  if (alreadyExist) 10.y,
                  if (alreadyExist)
                    ListTile(
                      onTap: () {
                        Navigate.to(context, const LinkBankScreen());
                      },
                      title: AppText(
                        'Link Bank',
                        style: Styles.circularStdRegular(context, fontSize: 18),
                      ),
                      leading: Icon(Icons.account_balance, size: 24.sp),
                      trailing:
                          Icon(Icons.arrow_forward_ios_sharp, size: 12.sp),
                    ),
                  if (!alreadyExist) 10.y,
                  if (!alreadyExist)
                    ListTile(
                      onTap: () {
                        Navigate.toReplace(context, const ExportProfile());
                      },
                      title: AppText(
                        AppStrings.becomeExpert,
                        style: Styles.circularStdRegular(context, fontSize: 18),
                      ),
                      leading: Icon(Icons.person, size: 24.sp),
                      trailing:
                          Icon(Icons.arrow_forward_ios_sharp, size: 12.sp),
                    ),
                ],
              ),
        listener: (BuildContext context, Object? state) {
          if (state is ErrorExpertDashboardState) {
            Navigate.pop(context);
            WidgetFunctions.instance.showErrorSnackBar(
              context: context,
              error: state.error,
            );
          }
          if (state is LoadingExpertDashboardState) {
            LoadingDialog.showLoadingDialog(context);
          }
          if (state is LoadedtExpertState) {
            alreadyExist = state.hasExpertProfile;
            isActive = state.isActive;
            Navigate.pop(context);
          }

          if (state is CancelledExpertState) {
            Navigate.pop(context);

            alreadyExist = false;
            WidgetFunctions.instance.showErrorSnackBar(
              context: context,
              error: "Expert subscription cancelled successfully!",
            );
          }
        },
      ),
    );
  }

  void _cancelSubscription(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: false,
      builder: (ctx) {
        return Container(
          height: 270,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.y,
                AppText(
                  maxLine: 3,
                  'Cancel subscription',
                  style: Styles.circularStdBold(
                    context,
                    fontSize: 24,
                  ),
                ),
                10.y,
                AppText(
                  maxLine: 3,
                  'Are you sure you want to cancel the subscription?',
                  style: Styles.circularStdMedium(
                    context,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                CustomButton(
                    onTap: () {
                      Navigate.pop(context);
                      context.read<ExpertDashboardCubit>().cancelSubscription();
                    },
                    text: 'Cancel subscription'),
                10.y,
              ],
            ),
          ),
        );
      },
    );
  }

  void _pauseExpertProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: false,
      builder: (ctx) {
        return Container(
          height: 270,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.y,
                AppText(
                  maxLine: 3,
                  isActive ? 'Pause expert profile' : 'Enable expert profile',
                  style: Styles.circularStdBold(
                    context,
                    fontSize: 24,
                  ),
                ),
                10.y,
                AppText(
                  maxLine: 3,
                  isActive
                      ? 'Are you sure you want to pause your expert profile?'
                      : 'Are you sure you want to enable your expert profile?',
                  style: Styles.circularStdMedium(
                    context,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  onTap: () {
                    Navigate.pop(context);
                    if (isActive) {
                      context
                          .read<ExpertDashboardCubit>()
                          .pauseProfile("freezed");
                    } else {
                      context
                          .read<ExpertDashboardCubit>()
                          .pauseProfile("active");
                    }
                  },
                  text: isActive ? 'Pause profile' : "Enable profile",
                ),
                10.y,
              ],
            ),
          ),
        );
      },
    );
  }
}
