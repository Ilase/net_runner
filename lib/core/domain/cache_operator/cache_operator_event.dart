part of 'cache_operator_bloc.dart';


abstract class CacheOperatorEvent {}

class LoadDataCacheOperatorEvent extends CacheOperatorEvent{}
class SaveDataCacheOperatorEvent extends CacheOperatorEvent{
  final String data;
  SaveDataCacheOperatorEvent({required this.data});
}