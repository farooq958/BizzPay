abstract class ExpertDashboardState {}

class InitialExpertDashboardState extends ExpertDashboardState {}

class LoadingExpertDashboardState extends ExpertDashboardState {}

class LoadedtExpertState extends ExpertDashboardState {
  final bool hasExpertProfile;
  final bool isActive;

  LoadedtExpertState({required this.hasExpertProfile, required this.isActive});
}

///
class CancelledExpertState extends ExpertDashboardState {}

class ErrorExpertDashboardState extends ExpertDashboardState {
  final String error;

  ErrorExpertDashboardState({required this.error});
}
