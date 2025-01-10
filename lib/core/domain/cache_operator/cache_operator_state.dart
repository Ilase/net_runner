part of 'cache_operator_bloc.dart';


abstract class CacheOperatorState {}

class CacheOperatorInitial extends CacheOperatorState {}
class CacheOperatorEmptyState extends CacheOperatorState {}
class CacheOperatorLoadedState extends CacheOperatorState {
  final String data;
  CacheOperatorLoadedState({required this.data});
}
class CacheOperatorErrorState extends CacheOperatorState{
  final String message;
  CacheOperatorErrorState({required this.message});
}