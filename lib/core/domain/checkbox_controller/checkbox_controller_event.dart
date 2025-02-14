part of 'checkbox_controller_bloc.dart';

@immutable
sealed class CheckboxControllerEvent {}
class AddItemEvent extends CheckboxControllerEvent{
  final String item;
  AddItemEvent({required this.item});
}
class DelItemEvent extends CheckboxControllerEvent{
  final String item;
  DelItemEvent({required this.item});
}
class ClearItemsEvent extends CheckboxControllerEvent{}