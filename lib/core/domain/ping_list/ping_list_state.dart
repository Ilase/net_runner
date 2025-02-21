part of 'ping_list_cubit.dart';

@immutable
sealed class PingListState {}

final class PingListInitial extends PingListState {}

class FilledPingState extends PingListState {
  final Map<String, dynamic> list;
  FilledPingState({required this.list});
}

class EmptyState extends PingListState {}
