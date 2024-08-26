import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Application/Services/PickerServices/picker_services.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/Badges/badgeModel.dart';
import 'package:buysellbiz/Domain/Brokers/broker_list_model.dart';
import 'package:buysellbiz/Domain/User/user_model.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/add_image_widget.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/display_images.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/SendBadgeRequest/Controller/send_badge_request_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/SendBadgeRequest/Controller/send_badge_request_state.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/chat_details.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/chat_navigation.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/YourBusinessList/UpdateBusiness/Components/update_business_details.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/add_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendBadgeRequest extends StatefulWidget {
  const SendBadgeRequest({
    super.key,
    this.badgeData,
    this.onSendReq,
    this.expertData,
    this.businessId,
    this.type,
  });

  final BadgeModel? badgeData;
  final BrokersListModel? expertData;
final Function? onSendReq;
  final String? businessId;
  final String? type;
  @override
  State<SendBadgeRequest> createState() => _SendBadgeRequestState();
}

class _SendBadgeRequestState extends State<SendBadgeRequest> {
  PlatformFile? upload;

  TextEditingController controller = TextEditingController();

  String? requestMessage;

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("Business Id ${widget.businessId}");
    print("Type ${widget.type}");
print(widget.expertData);
    return Scaffold(
      appBar:widget.expertData!=null? AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText("Send Badge Request",
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
      ):null,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.sp),
        child: Form(
          key: _key,
          child: Column(
            children: [
              10.y,
              AddImageWidget(
                attachFile: Assets.uploadAttachment,
                onTap: () async {
                  var pickedFile = await PickFile.pickFiles();
                  if (pickedFile != null) {
                    upload = pickedFile;
                    setState(() {});
                  }
                },
                height: 82,
                width: 400.w,
                text: 'Upload Documents',
              ),
              upload != null
                  ? DisplayFile(
                      file: upload,
                      onDeleteTap: () {
                        upload = null;
                        setState(() {});
                      },
                      index: 0,
                    )
                  : 10.x,
              10.y,
              CustomTextFieldWithOnTap(
                  validateText: 'Description Required',
                  maxline: 5,
                  controller: controller,
                  hintText: "Write Description",
                  textInputType: TextInputType.text),
              20.y,
              BlocConsumer<SendBadgeRequestCubit, SendBadgeRequestState>(
                listener: (context, state) {
                  if (state is SendBadgeRequestLoading) {
                    LoadingDialog.showLoadingDialog(context);
                  }
                  if (state is SendBadgeRequestLoaded) {
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
                  if (state is SendBadgeRequestError) {
                    Navigator.pop(context);
                    WidgetFunctions.instance
                        .snackBar(context, text: state.error);
                  }
                },
                builder: (context, state) {
                  return ValueListenableBuilder(
                      valueListenable: ChatNavigation.brokerChatLoading,
                      builder: (context, state, _) {
                        return state == 1
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CustomButton(
                                onTap: () {
                                  if (_key.currentState!.validate()) {
                                    if (upload != null) {
                                      if (upload!.path!.contains(".pdf")) {


                                        if(widget.expertData!=null){


                                        _requestConfirmation(context);
                                        }
                                        else
                                          {
                                            widget.onSendReq!(controller.text.trim(),upload!.path);


                                          }
                                      } else {
                                        WidgetFunctions.instance.snackBar(
                                            context,
                                            text: "File type not supported");
                                      }
                                    } else {
                                      WidgetFunctions.instance.snackBar(context,
                                          text: "Document required");
                                    }
                                  }
                                },
                                text: "Send Request");
                      });
                },
              ),
              20.y,
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _requestConfirmation(BuildContext context) {
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
                  'Are you sure you want request for ${widget.badgeData!.title} for \$${widget.badgeData!.price}',
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
                              "expertId": widget.expertData!.id,
                              "badgeId": widget.badgeData!.id,
                              "message": controller.text.trim(),
                              "type": widget.type,
                              "bussinessId": widget.businessId,
                            }
                          : {
                              "expertId": widget.expertData!.id,
                              "badgeId": widget.badgeData!.id,
                              "message": controller.text.trim(),
                              "type": widget.type,
                              // "bussinessId":widget.businessId,
                            };

                      requestMessage =
                          "Badge Name:${widget.badgeData?.title}\n BadgePrice:${widget.badgeData?.price}\n Document:${upload?.path}\n Message:${controller.text.trim()}";

                      setState(() {});

                      User? user = Data.app.user!.user;

                      if (user?.stripeCustomer?.cardAttached == true) {
                        context.read<SendBadgeRequestCubit>().sendBadgesRequest(
                            data: data,
                            context: context,
                            pathName: upload!.path);
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
}
