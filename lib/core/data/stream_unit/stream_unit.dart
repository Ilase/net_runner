import 'package:equatable/equatable.dart';
import 'package:net_runner/core/data/unit_params/unit_types.dart';

class StreamUnit<T> extends Equatable {
  final UnitType unitType;
  final StreamUnitStatus status;
  final T data;

  const StreamUnit({
    required this.unitType,
    required this.status,
    required this.data,
  });

  @override
  List<Object?> get props => [unitType, data];
}
