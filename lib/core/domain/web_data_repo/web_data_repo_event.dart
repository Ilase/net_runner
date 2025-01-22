part of 'web_data_repo_bloc.dart';

abstract class ElementEvent {}

class AddOrUpdateElement extends ElementEvent {
  final Map<String, dynamic> element;

  AddOrUpdateElement(this.element);
}

class SetElements extends ElementEvent {
  final List<Map<String, dynamic>> elements;

  SetElements(this.elements);
}