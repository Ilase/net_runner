part of 'string_list_bloc.dart';

@immutable
sealed class StringListState{}

final class StringListInitial extends StringListState {}
final class StringListReadyState extends StringListState {
  final List<String> dataList;
  StringListReadyState(this.dataList);
}
final class StringListErrorState extends StringListState {
  final String message;
  StringListErrorState(this.message);
}