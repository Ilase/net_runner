part of 'ping_list_cubit.dart';

@immutable
sealed class PingListState {}

final class PingListInitial extends PingListState {}
class EmptyState extends PingListState {}
class FullState extends PingListState {
  final Map<String,dynamic> pingMap;
  FullState({required this.pingMap});
}

