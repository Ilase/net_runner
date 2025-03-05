part of 'graph_report_list_cubit.dart';

@immutable
sealed class GraphReportListState {}

final class GraphReportListInitial extends GraphReportListState {}

class GetNetworkScanList extends GraphReportListState {}

class EmptyNetworkScanList extends GraphReportListState {}
