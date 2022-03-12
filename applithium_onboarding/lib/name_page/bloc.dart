import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core_onboarding/controller.dart';

import 'events.dart';
import 'state.dart';

class UserNamePageBloc extends AplBloc<UserNamePageState> {
  UserNamePageBloc(OnboardingController controller,
      {Function()? onBack, Function()? onContinue})
      : super(UserNamePageState()) {
    controller.markAsShown();
    doOn<BackClicked>((event, emit) {
      onBack?.call();
    });
    doOn<ContinueClicked>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await controller.onNameEntered(state.userName);
      if (result.isError) {
        emit(state.copyWith(error: result.asError, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
        onContinue?.call();
      }
    });
    doOn<NameChanged>((event, emit) {
      emit(state.copyWith(
          userName: event.name,
          isContinueEnabled: _isUserNameValid(event.name)));
    });
  }

  bool _isUserNameValid(String? name) {
    return name != null && name.length >= 3;
  }
}
