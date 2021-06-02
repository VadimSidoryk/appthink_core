import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/logs/extension.dart';

class AnalyticsBlocAdapter extends BlocsListener {

  final AnalyticsService analytics;

  AnalyticsBlocAdapter(this.analytics);

  @override
  void onError(BaseBloc bloc, e) {
    logMethod(methodName: "onError", params: [bloc, e]);
    logError(e);
  }

  @override
  void onNewEvent(BaseBloc bloc, BaseEvents event) {
    logMethod(methodName: "onNewEvent", params: [bloc, event]);
    analytics.trackEventWithParams(event.analyticTag, event.analyticParams);
  }

  @override
  void onNewState(BaseBloc bloc, BaseState state) {
    logMethod(methodName: "onNewState", params: [bloc, state]);
  }
}