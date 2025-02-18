part of 'base_url_cubit.dart';

abstract class BaseUrlState {}

final class BaseUrlInitial extends BaseUrlState {}

class StringState extends BaseUrlState {
  final String? baseUrl;
  StringState({required this.baseUrl});
}

class EmptyState extends BaseUrlState {}
