import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/Brokers/broker_list_model.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/chip_widget.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/chat_navigation.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Home/Controller/Brokers/broker_by_id_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Home/Controller/Brokers/brokers_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrokerProfile extends StatefulWidget {
  const BrokerProfile({super.key, this.id});

  final String? id;

  @override
  State<BrokerProfile> createState() => _BrokerProfileState();
}

class _BrokerProfileState extends State<BrokerProfile> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    context.read<BrokerByIdCubit>().getBrokersById(brokerId: widget.id);
    // TODO: implement initState
    super.initState();
  }

  List serviceOffered = [
    'Business',
    'Business marketing',
    'Marketing',
    'Financing assistance',
    'Confidential business marketing'
  ];
  List industry = [
    'Automobile',
    'Education',
    'Construction',
    'Wholesale business',
    'Franchises'
  ];

  BrokersListModel? model;

  @override
  Widget build(BuildContext context) {
    print("this the id ${widget.id}");

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<BrokerByIdCubit, BrokerByIdState>(
          listener: (context, state) {
            print("here is the state $state");

            if (state is BrokerByIdLoading) {
              LoadingDialog.showLoadingDialog(context);
            }
            if (state is BrokerByIdLoaded) {
              model = state.model;
              print(state.model);
              Navigator.of(context).pop(true);
            }
            if (state is BrokerByIdError) {
              Navigator.pop(context);
              WidgetFunctions.instance
                  .showErrorSnackBar(context: context, error: state.error!);
            }
          },
          builder: (context, state) {
            return state is BrokerByIdLoaded
                ? NestedScrollView(
                    controller: controller,
                    headerSliverBuilder: (context, check) {
                      return [
                        // SliverAppBar(
                        //   expandedHeight:
                        //       MediaQuery.of(context).size.height * 0.38,
                        //   automaticallyImplyLeading: false,
                        //   backgroundColor: AppColors.whiteColor,
                        //   flexibleSpace: SingleChildScrollView(
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     child: Column(
                        //       children: [
                        //         16.y,
                        //         Padding(
                        //           padding: EdgeInsets.symmetric(
                        //             horizontal: 20.sp,
                        //           ),
                        //           child: const Align(
                        //               alignment: Alignment.centerLeft,
                        //               child: BackArrowWidget()),
                        //         ),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             CachedImage(
                        //               isCircle: true,
                        //               isFromProfilePic: true,
                        //               url:
                        //                   "${ApiConstant.baseurl}/${model?.userInfo?.profilePic}",
                        //               height: 108.h,
                        //               width: 120.w,
                        //             ),
                        //           ],
                        //         ),
                        //         12.y,
                        //         Align(
                        //           alignment: Alignment.center,
                        //           child: AppText(
                        //               "${model?.firstName}${model?.lastName}",
                        //               style: Styles.circularStdBold(context,
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 21.sp)),
                        //         ),
                        //         4.y,
                        //         Align(
                        //           alignment: Alignment.center,
                        //           child: AppText(
                        //               model?.experties?.profession ?? "",
                        //               style: Styles.circularStdRegular(context,
                        //                   fontWeight: FontWeight.w400,
                        //                   fontSize: 14.sp,
                        //                   color: AppColors.greyTextColor)),
                        //         ),
                        //         10.y,
                        //         model?.badges != null
                        //             ? Wrap(
                        //                 children: model!.badges!.map((e) {
                        //                   print(
                        //                       " here is icon ${ApiConstant.baseurl}/${e.icon}");

                        //                   return CachedImage(
                        //                     radius: 15.sp,
                        //                     url:
                        //                         "${ApiConstant.baseurl}${e.icon}",
                        //                   );
                        //                 }).toList(),
                        //               )
                        //             : const SizedBox(),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ];
                    },
                    body: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              16.y,
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.sp,
                                ),
                                child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: BackArrowWidget()),
                              ),
                              Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).width * 0.5,
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                  child: CachedImage(
                                    isCircle: true,
                                    isFromProfilePic: true,

                                    url:
                                        "${ApiConstant.baseurl}/${model?.userInfo?.profilePic}",

                                    // width: 120.w,
                                  ),
                                ),
                              ),
                              16.y,
                              Align(
                                alignment: Alignment.center,
                                child: AppText(
                                    "${model?.firstName} ${model?.lastName}",
                                    style: Styles.circularStdBold(context,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 21.sp)),
                              ),
                              4.y,
                              Align(
                                alignment: Alignment.center,
                                child: AppText(
                                    model?.experties?.profession ?? "",
                                    style: Styles.circularStdRegular(context,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: AppColors.greyTextColor)),
                              ),
                              10.y,
                              model?.badges != null
                                  ? Wrap(
                                      children: model!.badges!.map((e) {
                                        return CachedImage(
                                          radius: 25.sp,
                                          url:
                                              "${ApiConstant.baseurl}${e.icon}",
                                        );
                                      }).toList(),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        model?.userInfo?.id != Data.app.user?.user?.id
                            ? ValueListenableBuilder(
                                valueListenable:
                                    ChatNavigation.brokerChatLoading,
                                builder: (context, val, child) {
                                  return Positioned(
                                    bottom: 16.sp,
                                    left: 10.sp,
                                    right: 10.sp,
                                    child: val == 1
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : CustomButton(
                                            width: 300.w,
                                            height: 40.h,
                                            onTap: () {
                                              ChatNavigation.initChatWithBroker(
                                                  context,
                                                  model?.userInfo?.id ?? "",
                                                  model?.id ?? "");
                                              // Navigate.to(
                                              //     context,
                                              //     ChatDetailsScreen(
                                              //       model: ChatTileModel(
                                              //           message: 'Thank You',
                                              //           messageLength: '1',
                                              //           name: 'Gabriel Tasse',
                                              //           pr0fileImage: 'assets/images/chat1.png',
                                              //           time: '03:30 PM',
                                              //           title: ';dlas;jdaskdj'),
                                              //     ));
                                            },
                                            text:
                                                'Chat with ${model?.firstName}',
                                            borderRadius: 40.sp),
                                  );
                                })
                            : const SizedBox(),
                      ],
                    ),
                  )
                : state is BrokerByIdError
                    ? Center(
                        child: AppText(
                          state.error!,
                          style: Styles.circularStdRegular(context),
                        ),
                      )
                    : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  customRow(String title, String subTitle) {
    return Row(
      children: [
        Container(
          width: 5.0,
          height: 5.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        ),
        15.x,
        AppText(title,
            style: Styles.circularStdRegular(
              context,
              fontSize: 16.sp,
              color: AppColors.blackColor,
            )),
        80.x,
        Expanded(
          child: AppText(subTitle,
              style: Styles.circularStdRegular(
                context,
                fontSize: 16.sp,
                color: AppColors.blackColor,
              )),
        ),
      ],
    );
  }
}
