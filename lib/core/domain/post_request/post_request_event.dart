part of 'post_request_bloc.dart';


abstract class PostRequestEvent extends Equatable {


  const PostRequestEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostRequestEvent extends PostRequestEvent {}

class PostRequestGetEvent extends PostRequestEvent {
  final String uri;
  const PostRequestGetEvent({required this.uri});
}
class PostRequestSendEvent extends PostRequestEvent {
  final String uri;
  final Map<String, dynamic> body;
  const PostRequestSendEvent({required this.uri, required this.body});
}