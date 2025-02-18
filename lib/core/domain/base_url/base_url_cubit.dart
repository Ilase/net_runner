import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'base_url_state.dart';

class BaseUrlCubit extends Cubit<BaseUrlState> {
  String? baseUrl;
  BaseUrlCubit() : super(BaseUrlInitial());

  /// update baseUrl . all network blocs need to use state of this cubit!!
  void updateBaseUrl(String socket) {
    baseUrl = 'http://' + socket + '/api/v1';
    emit(StringState(baseUrl: baseUrl));
  }

  void clearBaseUrl() {
    baseUrl = null;
    emit(EmptyState());
  }
}
