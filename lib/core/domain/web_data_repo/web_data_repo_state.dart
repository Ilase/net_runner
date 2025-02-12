part of 'web_data_repo_bloc.dart';


class ElementState {
  final List<Map<String, dynamic>> elements;

  ElementState(this.elements);

  ElementState copyWith({List<Map<String, dynamic>>? elements}) {
    return ElementState(elements ?? this.elements);
  }
}


