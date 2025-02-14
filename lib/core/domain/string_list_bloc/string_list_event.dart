part of 'string_list_bloc.dart';

@immutable
sealed class StringListEvent {}

class StringListAddElementEvent extends StringListEvent {
  final String element;
  StringListAddElementEvent(this.element);
}
class StringListClearEvent extends StringListEvent {}