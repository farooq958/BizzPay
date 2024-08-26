import 'dart:convert';
import 'dart:developer';

import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/AppData/app_preferences.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/Badges/badgeModel.dart';
import 'package:buysellbiz/Domain/Brokers/broker_list_model.dart';
import 'package:buysellbiz/Domain/User/user_model.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/chip_widget.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/SendBadgeRequest/Controller/send_badge_request_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/SendBadgeRequest/Controller/send_badge_request_state.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/SendBadgeRequest/send_badge_request.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/ShowExpertProfiles/Controller/show_experts_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/ShowExpertProfiles/Controller/show_experts_state.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_appbar.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/add_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';

class ShowTheExpertProfiles extends StatefulWidget {
  final BadgeModel? badgesModel;
  final String? businessId;
  final String? type;

  // final void Function(BrokersListModel val) getData;

  const ShowTheExpertProfiles(
      {super.key, this.badgesModel, this.businessId, this.type});

  @override
  State<ShowTheExpertProfiles> createState() => _ShowTheExpertProfilesState();
}

class _ShowTheExpertProfilesState extends State<ShowTheExpertProfiles> {
  List<BrokersListModel>? profileData;
  String? badgeStatus;

  @override
  void initState() {
    getBadgeStat();
    context
        .read<ShowExpertsCubit>()
        .getShowExperts(badgeID: widget.badgesModel!.id);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print("businneessss${widget.businessId}");
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Brokers',
        leading: true,
      ),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: BlocConsumer<ShowExpertsCubit, ShowExpertsState>(
          listener: (context, state) async {
            if (state is ShowExpertsLoading) {
              LoadingDialog.showLoadingDialog(context);
            }
            if (state is ShowExpertsLoaded) {
              // profileData = state.profileData;
              Navigator.of(context).pop(true);
              if (state.profileData!.isNotEmpty && badgeStatus != 'sentReq') {
                SharedPrefs.setBadgeString(
                    widget.badgesModel!.id!, 'available');
                getBadgeStat();
                log("LENGTH: ${state.profileData!.length}");
                Navigate.toReplace(
                  context,
                  SendBadgeRequest(
                    badgeData: widget.badgesModel,
                    expertData: state.profileData!.first,
                    type: widget.type,
                    businessId: widget.businessId,
                  ),
                );
              }
              else
              if (state.profileData!.isNotEmpty && badgeStatus == 'sentReq') {
                String? prefsData = SharedPrefs.getBadgeString(
                    "badge${widget.badgesModel!.id!}");

                Map<String, dynamic> data = jsonDecode(prefsData!);
                BadgeModel badgeData = BadgeModel.fromJson(data['badgeData']);
                // BrokersListModel expertData= BrokersListModel.fromJson(data['expertData']);
                String message = data['message'];
                String docPath = data['docPath'];
                String type = data['type'];
                String? bussinessId = data['bussinessId'];
                Map<String, dynamic> dataToSend = {
                  "badgeData": badgeData,
                  "expertId": state.profileData!.first.id
                  ,
                  "message": message,
                  "docPath": docPath,
                  "type": type,
                  "bussinessId": bussinessId,
                };
                _requestConfirmation(context, dataToSend, badgeData);
              }
              else {
                if (badgeStatus != null && badgeStatus == 'sentReq') {


                }
                else {
                  await SharedPrefs.setBadgeString(
                      widget.badgesModel!.id!, 'pending').then((vv) {
                    getBadgeStat();
                  });
                }
              }
            }
            if (state is ShowExpertsError) {
              WidgetFunctions.instance.snackBar(context, text: state.error);
            }
            // TODO: implement listener
          },
          builder: (context, state) {
            print(" badge Status $badgeStatus akkdads");
            return state is ShowExpertsLoaded
                ?state.profileData!.isNotEmpty && badgeStatus=='sentReq' ?

            RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ShowExpertsCubit>()
                    .getShowExperts(badgeID: widget.badgesModel!.id);
              },
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Center(
                  child: ListView(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (1.sh / 3.4).y,
                      Center(
                        child: AppText(badgeStatus == 'pending'
                            ? 'No Expert found Please Send Request '
                            : 'Your Request have been Sent and is in Queue.Please Check Back Later',
                            maxLine: 3,
                            textAlign: TextAlign.center,
                            style: Styles.circularStdRegular(context,
                                fontSize: 14.sp)),
                      ),
                      badgeStatus == 'pending' ? SizedBox(
                          height: 500.h,
                          child: SendBadgeRequest(

                            badgeData: widget.badgesModel,
                            expertData: state.profileData!.firstOrNull,
                            type: widget.type,
                            onSendReq: (String? desc, String? path) async {
                              print('path $path');
                              print('desc $desc');
                              Map<String, dynamic> data = {
                                "badgeData": widget.badgesModel!.toJson(),
                                "expertData": state.profileData!.firstOrNull
                                    .toString(),
                                "message": desc,
                                "docPath": path,
                                "type": widget.type,
                                "bussinessId": widget.businessId,
                              };

                              await SharedPrefs.setBadgeString(
                                  widget.badgesModel!.id!, 'sentReq').then((
                                  valuee) async {
                                await SharedPrefs.setBadgeString(
                                    "badge${widget.badgesModel!.id!}",
                                    jsonEncode(data));

                                getBadgeStat();
                                context
                                    .read<ShowExpertsCubit>()
                                    .getShowExperts(
                                    badgeID: widget.badgesModel!.id);
                              });
                            },
                            businessId: widget.businessId,

                          )) :
                      BlocConsumer<SendBadgeRequestCubit, SendBadgeRequestState>(
                        listener: (context, sendState) {
                          if (sendState is SendBadgeRequestLoading) {
                            LoadingDialog.showLoadingDialog(context);
                          }
                          if (sendState is SendBadgeRequestLoaded) {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BottomNavigationScreen(),
                                ),
                                    (route) => false); // ChatNavigation.initChatWithBroker(
                            //   context,
                            //   widget.expertData!.userInfo!.id!,
                            //   widget.expertData!.id!,
                            // );
                          }
                          if (sendState is SendBadgeRequestError) {
                            Navigator.pop(context);
                            WidgetFunctions.instance
                                .snackBar(context, text: sendState.error);
                          }
                        },
                        builder: (context, ss) {
                          return Center(
                            child: InkWell(
                                onTap: () {
                                  context
                                      .read<ShowExpertsCubit>()
                                      .getShowExperts(
                                      badgeID: widget.badgesModel!.id);
                                },
                                child: Lottie.asset(
                                    "assets/images/retryAnim.json", height: 100,
                                    width: 200,
                                    fit: BoxFit.fitHeight)),
                          );
                        },
                      ),


                    ],
                  ),
                ),
              ),
            ):
            state.profileData!.isNotEmpty
                ? const SizedBox.shrink()

            // GridView.builder(
            //     gridDelegate:
            //         const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2, // Number of items per row
            //       crossAxisSpacing: 0.5, // Spacing between columns
            //       mainAxisSpacing: 10.5,
            //       childAspectRatio: 0.70, // Spacing between rows
            //     ),
            //     itemCount: state.profileData!.length,
            //     // Replace this with your actual data list length
            //     itemBuilder: (BuildContext context, int index) {
            //       // Replace this with your own widget or data for each grid item
            //       return GestureDetector(
            //         onTap: () {
            //           // getData(profileData![index]);
            //           Navigate.toReplace(
            //               context,
            //               SendBadgeRequest(
            //                 badgeData: widget.badgesModel,
            //                 expertData: state.profileData![index],
            //                 type: widget.type,
            //                 businessId: widget.businessId,
            //               ));
            //         },
            //         child: Container(
            //           margin: EdgeInsets.symmetric(horizontal: 12.sp),
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(15.sp),
            //               color: AppColors.whiteColor,
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.grey.withOpacity(0.3),
            //                   blurRadius: 1,
            //                   spreadRadius: 1,
            //                   offset: const Offset(0, 1),
            //                 )
            //               ]),
            //           child: Column(
            //             children: [
            //               5.y,
            //               Expanded(
            //                 child: CachedImage(
            //                   isCircle: true,
            //                   radius: 40.sp,
            //                   url:
            //                       "${ApiConstant.baseurl}${state.profileData![index].userInfo?.profilePic}",
            //                   height: 120.sp,
            //                   width: 120.sp,
            //                 ),
            //               ),
            //               15.y,
            //               AppText(
            //                   state.profileData![index].designation ??
            //                       "",
            //                   maxLine: 2,
            //                   style: Styles.circularStdRegular(context,
            //                       color: AppColors.lightGreyColor,
            //                       fontSize: 12.sp)),
            //               5.y,
            //               AppText(
            //                   "${state.profileData![index].firstName} ${state.profileData![index].lastName}",
            //                   maxLine: 2,
            //                   textAlign: TextAlign.center,
            //                   style: Styles.circularStdMedium(context,
            //                       fontSize: 18.sp)),
            //               5.y,
            //               SingleChildScrollView(
            //                 scrollDirection: Axis.horizontal,
            //                 child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.center,
            //                     children: [
            //                       for (int i = 0;
            //                           i <
            //                               profileData![index]
            //                                   .badges!
            //                                   .length;
            //                           i++)
            //                         CachedImage(
            //                             radius: 15,
            //                             url:
            //                                 "${ApiConstant.baseurl}/${profileData![index].badges![i].icon}")
            //                     ]),
            //               ),
            //               Expanded(
            //                 child: SingleChildScrollView(
            //                   scrollDirection: Axis.horizontal,
            //                   physics: const BouncingScrollPhysics(),
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       for (int i = 0;
            //                           i <
            //                               state.profileData![index]
            //                                   .industriesServed!.length;
            //                           i++)
            //                         ChipWidget(
            //                           chipColor: AppColors.primaryColor,
            //                           textColor: AppColors.whiteColor,
            //                           labelText: state
            //                               .profileData![index]
            //                               .industriesServed![i]
            //                               .title,
            //                           width: null,
            //                           height: 30,
            //                         ),
            //                     ],
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   )


                : RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ShowExpertsCubit>()
                    .getShowExperts(badgeID: widget.badgesModel!.id);
              },
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Center(
                  child: ListView(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (1.sh / 3.4).y,
                      Center(
                        child: AppText(badgeStatus == 'pending'
                            ? 'No Expert found Please Send Request '
                            : 'Your Request have been Sent and is in Queue.Please Check Back Later',
                            maxLine: 3,
                            textAlign: TextAlign.center,
                            style: Styles.circularStdRegular(context,
                                fontSize: 14.sp)),
                      ),
                      badgeStatus == 'pending' ? SizedBox(
                          height: 500.h,
                          child: SendBadgeRequest(

                            badgeData: widget.badgesModel,
                            expertData: state.profileData!.firstOrNull,
                            type: widget.type,
                            onSendReq: (String? desc, String? path) async {
                              print('path $path');
                              print('desc $desc');
                              Map<String, dynamic> data = {
                                "badgeData": widget.badgesModel!.toJson(),
                                "expertData": state.profileData!.firstOrNull
                                    .toString(),
                                "message": desc,
                                "docPath": path,
                                "type": widget.type,
                                "bussinessId": widget.businessId,
                              };

                              await SharedPrefs.setBadgeString(
                                  widget.badgesModel!.id!, 'sentReq').then((
                                  valuee) async {
                                await SharedPrefs.setBadgeString(
                                    "badge${widget.badgesModel!.id!}",
                                    jsonEncode(data));

                                getBadgeStat();
                                context
                                    .read<ShowExpertsCubit>()
                                    .getShowExperts(
                                    badgeID: widget.badgesModel!.id);
                              });
                            },
                            businessId: widget.businessId,

                          )) :
                      BlocConsumer<SendBadgeRequestCubit, SendBadgeRequestState>(
                        listener: (context, sendState) {
                          if (sendState is SendBadgeRequestLoading) {
                            LoadingDialog.showLoadingDialog(context);
                          }
                          if (sendState is SendBadgeRequestLoaded) {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BottomNavigationScreen(),
                                ),
                                    (route) => false); // ChatNavigation.initChatWithBroker(
                            //   context,
                            //   widget.expertData!.userInfo!.id!,
                            //   widget.expertData!.id!,
                            // );
                          }
                          if (sendState is SendBadgeRequestError) {
                            Navigator.pop(context);
                            WidgetFunctions.instance
                                .snackBar(context, text: sendState.error);
                          }
                        },
                        builder: (context, ss) {
                          return Center(
                            child: InkWell(
                                onTap: () {
                                  context
                                      .read<ShowExpertsCubit>()
                                      .getShowExperts(
                                      badgeID: widget.badgesModel!.id);
                                },
                                child: Lottie.asset(
                                    "assets/images/retryAnim.json", height: 100,
                                    width: 200,
                                    fit: BoxFit.fitHeight)),
                          );
                        },
                      ),


                    ],
                  ),
                ),
              ),
            )
                : state is ShowExpertsError
                ? Center(
                child: Text(
                  state.error ?? "",
                  style:
                  Styles.circularStdRegular(context, fontSize: 12.sp),
                ))
                : const SizedBox();
          },
        ),
      ),
    );
  }

  Future<dynamic> _requestConfirmation(BuildContext context,
      Map<String, dynamic> dataTo, BadgeModel badgeData) {
    return showModalBottomSheet(
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
                  'Confirmation',
                  style: Styles.circularStdBold(
                    context,
                    fontSize: 24,
                  ),
                ),
                10.y,
                AppText(
                  maxLine: 3,
                  'Are you sure you want request for ${badgeData
                      .title} for \$${badgeData.price}',
                  style: Styles.circularStdMedium(
                    context,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                CustomButton(
                    onTap: () {
                      Navigate.pop(context);
                      Map<String, dynamic> data = widget.businessId != null
                          ? {
                        "expertId": dataTo['expertId'],
                        "badgeId": badgeData.id,
                        "message": dataTo['message'],
                        "type": dataTo['type'],
                        "bussinessId": dataTo['bussinessId'],
                      }
                          : {
                        "expertId": dataTo['expertId'],
                        "badgeId": badgeData.id,
                        "message": dataTo['message'],
                        "type": dataTo['type'],
                        // "bussinessId":widget.businessId,
                      };


                      setState(() {});

                      User? user = Data.app.user!.user;

                      if (user?.stripeCustomer?.cardAttached == true) {
                        context.read<SendBadgeRequestCubit>().sendBadgesRequest(
                            data: data,
                            context: context,
                            pathName: dataTo['docPath']);
                      } else {
                        Navigate.to(context, const StripeCardWidget());
                      }
                    },
                    text: 'Continue'),
                10.y,
              ],
            ),
          ),
        );
      },
    );
  }

  void getBadgeStat({bool? fromInit}) {
    badgeStatus = SharedPrefs.getBadgeString(widget.badgesModel!.id!);
    if (badgeStatus != null) {
      // SharedPrefs.setBadgeString(widget.badgesModel!.id!, false);


    }
    else {
      badgeStatus = 'pending';
    }
  }
}


/// CustomButton(onTap: () async {
//                                await SharedPrefs.setBadgeString(widget.badgesModel!.id!, 'sentReq').then((valuee){
//
//                                  getBadgeStat();
//                                  context
//                                      .read<ShowExpertsCubit>()
//                                      .getShowExperts(badgeID: widget.badgesModel!.id);
//                                });
//
//
//                               }, text: "Send Request",horizontalMargin: 60,)