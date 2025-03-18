part of 'diff_data_generator_cubit.dart';

@immutable
sealed class DiffDataGeneratorState {}

final class DiffDataGeneratorInitial extends DiffDataGeneratorState {}

class LoadingDataDiffState extends DiffDataGeneratorState {}

class LoadedDataDiffState extends DiffDataGeneratorState {}

class LoadedErrorDiffState extends DiffDataGeneratorState {}
