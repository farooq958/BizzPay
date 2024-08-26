import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Data/DataSource/Resources/validator.dart';
import 'package:buysellbiz/Presentation/Common/ContextWidgets/success_snackbar.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/add_image_widget.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/custom_dropdown.dart';
import 'package:buysellbiz/Presentation/Common/dialog.dart';
import 'package:buysellbiz/Presentation/Common/display_images.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Controllers/Repo/Report/reportUser.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_appbar.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Controller/CustomerSupport/customer_support_cubit.dart';
import 'package:buysellbiz/Application/Services/PickerServices/picker_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportChatUser extends StatefulWidget {
  const ReportChatUser({super.key, this.userID});

  final String? userID;

  @override
  State<ReportChatUser> createState() => _ReportChatUserState();
}

class _ReportChatUserState extends State<ReportChatUser> {
  TextEditingController reportController = TextEditingController();

  List how = [
    'Fraud',
    "Communication",
    'illegal activity',
    "Inappropriate content",
    "Abusive or harassing behavior",
  ];

  String? why;

  final _formKey = GlobalKey<FormState>();

  bool imageValid = false;
  List<String?>? images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CustomAppBar(
        title: "Report User",
        leading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.y,
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropDownWidget(
                      hMargin: 0,
                      vMargin: 0,
                      value: why,
                      itemsMap: how.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (onChanged) {
                        why = onChanged;
                        setState(() {});
                      },
                      prefixIcon: SvgPicture.asset(Assets.person),
                      hintText: 'Reason',
                      validationText: 'Field Required',
                    ),
                    10.y,
                    CustomTextFieldWithOnTap(
                        validateText: 'Field Required',
                        height: 100.h,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.sp, horizontal: 10.sp),
                        maxline: 5,
                        borderRadius: 10.r,
                        controller: reportController,
                        hintText: 'Report',
                        textInputType: TextInputType.emailAddress),
                    30.y,
                    CustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            LoadingDialog.showLoadingDialog(context);
                            var body = {
                              "text": reportController.text.trim(),
                              "reportOption": why,
                            };
                            await ReportUserRepo()
                                .reportUser(body: body, userId: widget.userID)
                                .then((value) {
                              Navigate.pop(context);
                              if (value['Success']) {
                                Navigate.pop(context);
                                WidgetFunctions.instance.showErrorSnackBar(
                                    context: context,
                                    error: "User Reported successful");
                              } else {
                                WidgetFunctions.instance.showErrorSnackBar(
                                    context: context, error: value['error']);
                              }
                            });
                          }
                        },
                        text: "Report User")
                  ],
                ),
              ),
              //const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
