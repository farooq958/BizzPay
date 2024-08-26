import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Requests/Components/ongoing_orders_tile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Requests/Components/pending_requests_tile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Requests/Components/tab_buttons.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Requests/Controller/get_all_badges_request_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/BadgesRequests/Controller/badges_request_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/BadgesRequests/State/badges_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BadgesRequestScreen extends StatefulWidget {
  const BadgesRequestScreen({super.key});

  @override
  State<BadgesRequestScreen> createState() => _BadgesRequestScreenState();
}

class _BadgesRequestScreenState extends State<BadgesRequestScreen> {
  bool isAccepted = true;
  bool isRev = false;
  bool isDelv = false;

  @override
  void initState() {
    context.read<BadgesRequestCubit>().getBadgesRequest();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText("Requests",
                style: Styles.circularStdMedium(context, fontSize: 18.sp)),
            20.x,
          ],
        ),
        centerTitle: true,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.0.sp),
          child: const BackArrowWidget(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0).r,
        child: BlocConsumer<BadgesRequestCubit, BadgesRequestState>(
          listener: (context, state) {
            if (state is BadgesRequestLoading) {
              LoadingDialog.showLoadingDialog(context);
            }
            if (state is BadgesRequestLoaded) {
              Navigator.of(context).pop(true);
            }
            if (state is BadgesRequestError) {
              Navigator.of(context).pop(true);
              WidgetFunctions.instance.snackBar(context, text: state.error);
            }
          },
          builder: (context, state) {
            return state is BadgesRequestError
                ? Center(
                    child: AppText(state.error ?? '',
                        style:
                            Styles.circularStdBold(context, fontSize: 14.sp)),
                  )
                : state is BadgesRequestLoaded
                    ? Column(
                        children: [
                          20.y,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TabButton(
                                  active: isAccepted,
                                  title: 'Accepted',
                                  onTap: () {
                                    setState(() {
                                      isAccepted = true;
                                      isRev = false;
                                      isDelv = false;
                                    });
                                  },
                                ),
                              ),
                              5.x,
                              Expanded(
                                child: TabButton(
                                  active: isDelv,
                                  title: 'Deliver/reject',
                                  onTap: () {
                                    setState(() {
                                      isAccepted = false;
                                      isRev = false;
                                      isDelv = true;
                                    });
                                  },
                                ),
                              ),
                              5.x,
                              Expanded(
                                child: TabButton(
                                  active: isRev,
                                  title: 'Revisions',
                                  onTap: () {
                                    setState(() {
                                      isRev = true;
                                      isAccepted = false;
                                      isDelv = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          10.y,
                          ((isAccepted && state.accepted.isNotEmpty) ||
                                  (isDelv && state.delivered.isNotEmpty) ||
                                  (isRev && state.revision.isNotEmpty))
                              ? Expanded(
                                  child: ListView.separated(
                                    padding: EdgeInsets.only(bottom: 10.sp),
                                    separatorBuilder: (context, index) {
                                      return 13.y;
                                    },
                                    itemCount: isAccepted
                                        ? state.accepted.length
                                        : isDelv
                                            ? state.delivered.length
                                            : state.revision.length,
                                    itemBuilder: (context, index) {
                                      return RequestTile(
                                        badgesRequest: isAccepted
                                            ? state.accepted[index]
                                            : isDelv
                                                ? state.delivered[index]
                                                : state.revision[index],
                                        isFromBusiness: true,
                                      );
                                    },
                                  ),
                                )
                              : AppText('No Request found',
                                  style: Styles.circularStdMedium(context))
                        ],
                      )
                    : const SizedBox();
          },
        ),
      ),
    );
  }
}
