part of 'host_list_cubit.dart';

@immutable
sealed class HostListState {}

class HostListInitialState extends HostListState{}
class FullState extends HostListState {
  final List<dynamic> hostList;
  FullState({required this.hostList});
}
class EmptyState extends HostListState {}
