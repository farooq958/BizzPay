import 'dart:developer';

import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Application/Services/PaymentServices/payment_services.dart';
import 'package:buysellbiz/Data/AppData/app_preferences.dart';
import 'package:buysellbiz/Data/AppData/app_secrets.dart';
import 'package:buysellbiz/Data/DataSource/Repository/Card/delete_card.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/User/user_model.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/dialog.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeCardWidget extends StatefulWidget {
  const StripeCardWidget({super.key, this.userModel});

  final UserModel? userModel;

  @override
  State<StripeCardWidget> createState() => _StripeCardWidgetState();
}

class _StripeCardWidgetState extends State<StripeCardWidget> {
  CardFormEditController cardEditController = CardFormEditController();

  String? clientSecretKey;

  bool loading = false;

  getKey() async {
    var val = await PaymentServices.getSecretForSetupIntent().then((value) {
      return value;
    });
    if (val['Success']) {
      log(val['body']['client_secret'].toString());
      clientSecretKey = val['body']["client_secret"];
      log(clientSecretKey.toString());
      setState(() {});
    } else {
      WidgetFunctions.instance.snackBar(context, text: val['error']);
    }
  }

  @override
  void initState() {
    // log('user mode here${Data.app.user?.user!.stripeCustomer!.cardDetails!.toJson()}');

    getKey();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          'Card Form',
          style: Styles.circularStdMedium(context, fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.y,
            Data.app.user?.user!.stripeCustomer!.cardAttached != true
                ? CardFormField(
                    style: CardFormStyle(
                        fontSize: 16,
                        borderWidth: 1,
                        borderRadius: 10,
                        borderColor: AppColors.borderColor,
                        textColor: AppColors.blackColor,
                        placeholderColor: AppColors.blackColor,
                        backgroundColor: AppColors.whiteColor),
                    controller: cardEditController)
                : Container(
                    padding: EdgeInsets.all(15.sp),
                    height: 120.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.whiteColor,
                        border: Border.all(color: Colors.black, width: 0.4)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText("Card Number",
                                    style: Styles.circularStdRegular(context,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500)),
                                AppText(
                                    Data.app.user?.user!.stripeCustomer
                                            ?.cardDetails?.last4 ??
                                        "",
                                    style: Styles.circularStdRegular(context,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText("Exp Date",
                                    style: Styles.circularStdRegular(context,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500)),
                                AppText(
                                    "${Data.app.user?.user!.stripeCustomer?.cardDetails?.expMonth}/${Data.app.user?.user!.stripeCustomer?.cardDetails?.expYear}",
                                    style: Styles.circularStdRegular(context,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ],
                        ),
                        10.y,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText("Card Type",
                                    style: Styles.circularStdRegular(context,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500)),
                                AppText(
                                    Data.app.user?.user!.stripeCustomer
                                            ?.cardDetails?.brand ??
                                        "",
                                    style: Styles.circularStdRegular(context,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            10.y,
            loading == true
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    onTap:
                        widget.userModel?.user?.stripeCustomer?.cardAttached ==
                                true
                            ? _removeCard
                            : _addCard,
                    text:
                        widget.userModel?.user?.stripeCustomer?.cardAttached ==
                                true
                            ? "Remove Card"
                            : "Add Card")
          ],
        ),
      ),
    );
  }

  _getCardDetails() async {
    // Stripe int = Stripe.instance;
    // final CardParams cardParams = CardParams(id: cardId);
    // final Card card = await int.ret;
    // final cardDetails = await  await PaymentServices.;
    // print('Card details: ${cardDetails?.card}');
  }

  _removeCard() async {
    LoadingDialog.showLoadingDialog(context);

    await DeleteCard.deletePayment().then((value) {
      if (value['Success']) {
        Navigate.pop(context);
        WidgetFunctions.instance
            .snackBar(context, text: "Payment Type Removed Successful");
        Navigate.pop(context);
        _setUserData(value);
      } else {
        WidgetFunctions.instance.snackBar(context, text: value['error']);
        Navigate.pop(context);
      }
    });
  }

  _addCard() async {
    if (cardEditController.details.complete) {
      loading = true;
      setState(() {});

      Stripe.publishableKey = stripeKey;

      await Stripe.instance
          .createToken(
        const CreateTokenParams.card(
          params: CardTokenParams(
            type: TokenType.Card,
          ),
        ),
      )
          .then((val) async {
        log("here is the token${val.id}");
        SetupIntent pi = await PaymentServices.setupPaymentIntent(
            clientSecret: clientSecretKey, cardToken: val.id);

        log("here is pi ${pi.toJson().toString()}");

        await PaymentServices.verifyPaymentIntent(
          paymentId: pi.paymentMethodId,
          setUpId: pi.id,
        ).then((value) {
          loading = false;
          setState(() {});
          if (value['Success']) {
            log("response here ${value.toString()}");

            _setUserData(value);
            WidgetFunctions.instance
                .snackBar(context, text: "Payment Type Added");
            Navigate.pop(context);
          }
        }).catchError((e) {
          WidgetFunctions.instance.snackBar(context, text: e.toString());
          loading = false;
          setState(() {});
          throw e;
        });
      }).catchError((e) {
        loading = false;
        setState(() {});
        WidgetFunctions.instance.snackBar(context, text: e.toString());
        throw e;
      });
    } else {
      WidgetFunctions.instance.snackBar(context, text: "Add Card Details");
    }
  }

  _setUserData(Map<String, dynamic> value) async {
    log("get Data $value");

    UserModel userData = UserModel.fromJson((value['body']));

    log("set Data ${userData.toJson().toString()}");

    await SharedPrefs.setUserLoginData(userRawData: userData);

    await SharedPrefs.getUserLoginData();
  }
}
