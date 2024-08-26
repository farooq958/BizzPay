import 'dart:developer';

import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/AppData/data.dart';
import 'package:buysellbiz/Data/DataSource/Repository/BadgesRepo/badges_repo.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/widget_functions.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/ExportDashBorad/Controller/expert_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpertDashboardCubit extends Cubit<ExpertDashboardState> {
  ExpertDashboardCubit() : super(InitialExpertDashboardState());

  Future getExpert() async {
    await Future.delayed(Duration.zero);
    emit(LoadingExpertDashboardState());
    return await BadgesRepo.checkExpertStatus().then(
      (value) {
        if (value['Success']) {
          emit(
            LoadedtExpertState(
              hasExpertProfile: value["body"]["hasExpertProfile"],
              isActive: value["body"]["status"] == "active" ? true : false,
            ),
          );
        } else {
          emit(ErrorExpertDashboardState(
              error: 'Error happened, please try again later!'));
        }
      },
    );
  }

  Future cancelSubscription() async {
    emit(LoadingExpertDashboardState());
    return await BadgesRepo.cancelSubscription().then(
      (value) {
        if (value['Success']) {
          emit(CancelledExpertState());
        } else {
          emit(ErrorExpertDashboardState(
              error: 'Error happened, please try again later!'));
        }
      },
    );
  }

  Future<void> pauseProfile(String status) async {
    LoadingDialog.showLoadingDialog(Data.app.navigatorKey.currentContext!);

    return await BadgesRepo.pauseSubscription(status).then(
      (value) {
        if (value['Success']) {
          Navigate.pop(Data.app.navigatorKey.currentContext!);
          getExpert();
        } else {
          Navigate.pop(Data.app.navigatorKey.currentContext!);
          WidgetFunctions.instance.showErrorSnackBar(
            context: Data.app.navigatorKey.currentContext!,
            error: "Error happened please try again later!",
          );
        }
      },
    );
  }
}
