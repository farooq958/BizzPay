import 'dart:developer';

import 'package:buysellbiz/Data/DataSource/Repository/BadgesRepo/badges_repo.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/Badges/badgeModel.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Badges/AllBadges/State/all_badges_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllBadgesCubit extends Cubit<AllBadgesState> {
  AllBadgesCubit() : super(AllBadgesInitialState());
  List<String> selectedBadgesId = [];

  void getBadges({String? type, String? businessID}) async {
    await Future.delayed(Duration.zero);
    emit(AllBadgesLoadingState());
    BadgesRepo.getBadges(type: type, businessID: businessID).then(
      (value) {
        if (value['Success']) {
          List<BadgeModel> badges = (value['body'] as List)
              .map((e) => BadgeModel.fromJson(e))
              .toList();
          emit(AllBadgesLoadedState(badges: badges));
        } else {
          emit(AllBadgesErrorState(error: value['error']));
        }
      },
    );
  }

  Future<bool> getExpert() async {
    await Future.delayed(Duration.zero);

    return await BadgesRepo.checkExpertStatus().then(
      (value) {
        if (value['Success']) {
          if (value["body"]["hasExpertProfile"]) {
            WidgetFunctions.instance.showErrorSnackBar(
                context: Data.app.navigatorKey.currentState!.context,
                error: 'Expert profile already exists!');
            return true;
          } else {
            return false;
          }
        } else {
          WidgetFunctions.instance.showErrorSnackBar(
              context: Data.app.navigatorKey.currentState!.context,
              error: 'Error happened, please try again later!');
          return false;
        }
      },
    );
  }

  void toggleSelection(String? id) {
    if (id != null) {
      if (selectedBadgesId.contains(id)) {
        selectedBadgesId.remove(id);
      } else {
        selectedBadgesId.add(id);
      }
      emit(AllBadgesSelectionState());
    }
  }

  bool checkSelection(String? id) => selectedBadgesId.contains(id);
}
