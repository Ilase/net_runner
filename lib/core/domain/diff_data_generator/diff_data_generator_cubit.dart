import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'diff_data_generator_state.dart';

class DiffDataGeneratorCubit extends Cubit<DiffDataGeneratorState> {
  DiffDataGeneratorCubit() : super(DiffDataGeneratorInitial());
}
