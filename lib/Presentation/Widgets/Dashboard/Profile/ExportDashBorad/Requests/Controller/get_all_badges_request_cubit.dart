import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:buysellbiz/Data/DataSource/Repository/BadgesRepo/badges_repo.dart';
import 'package:buysellbiz/Domain/Badges/BadgesRequest/badges_request.dart';
import 'package:meta/meta.dart';

part 'get_all_badges_request_state.dart';

class AllBadgesRequestCubit extends Cubit<AllBadgesRequestState> {
  AllBadgesRequestCubit() : super(AllBadgesRequestInitial());

  getBadgesRequest({bool? isBroker}) async {
    await Future.delayed(const Duration(microseconds: 10));
    emit(AllBadgesRequestLoading());
    try {
      await BadgesRepo.getAllBadgesRequests(isBroker: isBroker).then((value) {
        if (value['Success']) {
          List<BadgesRequest> badgesRequest =
              List.from(value['body'].map((e) => BadgesRequest.fromJson(e)));

          log(badgesRequest.first.toJson().toString());

          List<BadgesRequest> pending = badgesRequest
              .where((element) =>
                  element.status == "accepted" || element.status == "delivered")
              .toList();
          List<BadgesRequest> rejected = badgesRequest
              .where((element) =>
                  element.status == "rejected" || element.status == "revised")
              .toList();
          emit(AllBadgesRequestLoaded(pending: pending, rejected: rejected));
        } else {
          emit(AllBadgesRequestError(error: value['error']));
        }
      }).catchError((e) {
        emit(AllBadgesRequestError(error: e.toString()));
      });
    } catch (e) {
      emit(AllBadgesRequestError(error: e.toString()));
    }
  }
}
