import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'graph_report_list_state.dart';

class GraphReportListCubit extends Cubit<GraphReportListState> {
  GraphReportListCubit() : super(GraphReportListInitial());
}
