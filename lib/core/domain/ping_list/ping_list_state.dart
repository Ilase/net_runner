part of 'ping_list_cubit.dart';

@immutable
sealed class PingListState {}

final class PingListInitial extends PingListState {}

class PingListFilledState extends PingListState {
  final List<dynamic> list;
  PingListFilledState({required this.list});
}

class PingListEmptyState extends PingListState {}

class PingListLoadingState extends PingListState {}
