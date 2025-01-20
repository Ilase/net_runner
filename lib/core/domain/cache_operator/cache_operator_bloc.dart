import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cache_operator_event.dart';
part 'cache_operator_state.dart';

class CacheOperatorBloc extends Bloc<CacheOperatorEvent, CacheOperatorState> {
  final SharedPreferences sharedPreferences;

  CacheOperatorBloc({required this.sharedPreferences}) : super(CacheOperatorInitial());
  @override
  Stream<CacheOperatorState> mapEventToState(CacheOperatorEvent event) async*{
    if(event is SaveDataCacheOperatorEvent){
      try{
        await sharedPreferences.setString('cached_data', event.data);
        yield CacheOperatorLoadedState(data: event.data);
      } catch(e){
        yield CacheOperatorErrorState(message: 'Error saving data to cache: $e');
      }
    }
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
