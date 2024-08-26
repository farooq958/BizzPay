import 'dart:developer';

import 'package:buysellbiz/Application/Services/ApiServices/api_services.dart';
import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/AppData/app_secrets.dart';
import 'package:buysellbiz/Data/AppData/data.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentServices {
  static Future<SetupIntent> setupPaymentIntent(
      {String? clientSecret, String? cardToken}) async {
    log('Call Function');

    // Set the publishable key
    try {
      Stripe.publishableKey = stripeKey;

      // Initialize the PaymentSheet

      // Present the PaymentSheet to the user

      // Retrieve the PaymentIntent after payment is completed
      final pi = await Stripe.instance.confirmSetupIntent(
        paymentIntentClientSecret: clientSecret!,
        params: PaymentMethodParams.cardFromToken(
          paymentMethodData: PaymentMethodDataCardFromToken(token: cardToken!),
        ),
      );
      return pi;
    } on StripeException catch (e) {
      log(e.toString());
      throw Exception(e.error.message);
    } catch (e) {
      rethrow;
    }
    // Handle the retrieved PaymentIntent (pi) as needed
  }

  static Future<PaymentIntent> performStripeTransfer({
    required context,
    required clientSecret,
  }) async {
    try {
      log("here is card value ${Data.app.user?.user?.stripeCustomer?.cardAttached}");

      Stripe.publishableKey = stripeKey;
      // await Stripe.instance.
      if (Data.app.user?.user?.stripeCustomer?.cardAttached == true) {
        final pi = await Stripe.instance.retrievePaymentIntent(clientSecret);
        return pi;
      } else {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'BUYSELLBIZ',
            paymentIntentClientSecret: clientSecret,
          ),
        );
        await Stripe.instance.presentPaymentSheet();
        final pi = await Stripe.instance.retrievePaymentIntent(clientSecret);
        return pi;
      }
    } on StripeException catch (e) {
      log(e.toString());
      throw Exception(e.error.message);
    } catch (e) {
      rethrow;
    }
  }

  static verifySubscreptionPayment(String pi) async {
    var headers = {"authorization": " ${Data.app.token}"};

    return await ApiService.post(ApiConstant.verifyPayment, {'intentId': pi},
            header: headers)
        .then((value) {
      log("verifyPayment>> $value");
      return value;
    }).onError((error, stackTrace) =>
            {"Success": false, "error": error.toString()});
  }

  static verifyBadgePayment({Map<String, dynamic>? data}) async {
    var headers = {"authorization": " ${Data.app.token}"};

    return await ApiService.post(ApiConstant.badgePaymentVerify, data!,
            header: headers)
        .then((value) {
      log("verifyPayment>> $value");
      return value;
    }).onError((error, stackTrace) =>
            {"Success": false, "error": error.toString()});
  }

  static Future getSecretForSetupIntent() async {
    var headers = {"authorization": " ${Data.app.token}"};

    return await ApiService.get(ApiConstant.paymentSetup, headers: headers)
        .then((value) {
      log("Secret for setup intent>> $value");
      return value;
    }).onError((error, stackTrace) =>
            {"Success": false, "error": error.toString()});
  }

  static verifyBadgeViewPayment({Map<String, dynamic>? data}) async {
    var headers = {"authorization": " ${Data.app.token}"};

    return await ApiService.post(ApiConstant.verifyBadgeviewPayment, data!,
            header: headers)
        .then((value) {
      log("verifyPayment>> $value");
      return value;
    }).onError((error, stackTrace) =>
            {"Success": false, "error": error.toString()});
  }

// static Future performStripeTransfer({
//   required context,
//   required int payment,
// }) async {
//   return await ApiService.post('${ApiConstant.baseurl}/initatePayment', {
//     'amount': '${payment * 100}',
//   }).then((value) async {
//     if (value.containsKey('clientSecret')) {
//       try {
//         Stripe.publishableKey = stripeKey;
//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             merchantDisplayName: 'BUYSELLBIZ',
//             paymentIntentClientSecret: value['clientSecret'],
//           ),
//         );
//         await Stripe.instance.presentPaymentSheet();

  static verifyBoostPayment(
      {required String pi, required String businessId}) async {
    var headers = {"authorization": " ${Data.app.token}"};

    return await ApiService.post(ApiConstant.verifyBoostPayment,
            {'intentId': pi, "businessId": businessId}, header: headers)
        .then((value) {
      log("verifyPayment>> $value");
      return value;
    }).onError((error, stackTrace) =>
            {"Success": false, "error": error.toString()});
  }

  static Future verifyPaymentIntent(
      {required String paymentId, required String setUpId}) async {
    var headers = {"authorization": " ${Data.app.token}"};

    log('here is value getting');

    return await ApiService.post(ApiConstant.verifyPaymentIntent,
            {'paymentMethodId': paymentId, "setupIntentId": setUpId},
            header: headers)
        .then((value) {
      log("verifyPayment>> $value");
      return value;
    }).onError((error, stackTrace) =>
            {"Success": false, "error": error.toString()});
  }

// static Future performStripeTransfer({
//   required context,
//   required int payment,
// }) async {
//   return await ApiService.post('${ApiConstant.baseurl}/initatePayment', {
//     'amount': '${payment * 100}',
//   }).then((value) async {
//     if (value.containsKey('clientSecret')) {
//       try {
//         Stripe.publishableKey = stripeKey;
//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             merchantDisplayName: 'BUYSELLBIZ',
//             paymentIntentClientSecret: value['clientSecret'],
//           ),
//         );
//         await Stripe.instance.presentPaymentSheet();

//         final pi = await Stripe.instance
//             .retrievePaymentIntent(value['clientSecret']);

//         return pi;
//       } on StripeException catch (e) {
//         log(e.toString());
//         rethrow;
//       }
//     }
//   });
// }
}
