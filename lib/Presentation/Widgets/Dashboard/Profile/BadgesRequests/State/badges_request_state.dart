import 'package:buysellbiz/Domain/Badges/BadgesRequest/badges_request.dart';

abstract class BadgesRequestState {}

class BadgesRequestInitial extends BadgesRequestState {}

class BadgesRequestLoading extends BadgesRequestState {}

class BadgesRequestLoaded extends BadgesRequestState {
  final List<BadgesRequest> accepted;
  final List<BadgesRequest> delivered;
  final List<BadgesRequest> revision;

  BadgesRequestLoaded({
    required this.accepted,
    required this.delivered,
    required this.revision,
  });
}

class BadgesRequestError extends BadgesRequestState {
  final String? error;

  BadgesRequestError({this.error});
}
