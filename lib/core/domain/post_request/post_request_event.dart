part of 'post_request_bloc.dart';


abstract class PostRequestEvent extends Equatable {
  const PostRequestEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostRequestEvent extends PostRequestEvent {}