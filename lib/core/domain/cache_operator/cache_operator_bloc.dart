import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cache_operator_event.dart';
part 'cache_operator_state.dart';

class CacheOperatorBloc extends Bloc<CacheOperatorEvent, CacheOperatorState> {
  final SharedPreferences sharedPreferences;

  CacheOperatorBloc({required this.sharedPreferences}) : super(CacheOperatorInitial());
  @override
  Stream<CacheOperatorState> mapEventToState(CacheOperatorEvent event) async*{
    if(event is LoadDataCacheOperatorEvent) {
      try {
        final cachedData = sharedPreferences.getString('cached_data');
        if (cachedData != null) {
          yield CacheOperatorLoadedState(data: cachedData);
        } else {
          yield CacheOperatorEmptyState();
        }
      } catch (e) {
        yield CacheOperatorErrorState(
            message: 'Error loading data from cache: $e');
      }
    }
  }
}
