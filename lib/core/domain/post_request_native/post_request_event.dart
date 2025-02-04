part of 'post_request_bloc.dart';


abstract class PostRequestEvent extends Equatable {


  const PostRequestEvent();

  @override
  List<Object?> get props => [];
}

class ClearUriPostRequestEvent extends PostRequestEvent {}
class FetchPostRequestEvent extends PostRequestEvent {}

class UpdateUriPostRequestEvent extends PostRequestEvent {
  final String uri;
  const UpdateUriPostRequestEvent({required this.uri});
}

class PostRequestGetSingleTaskEvent extends PostRequestEvent {
  final String endpoint;
  const PostRequestGetSingleTaskEvent({required this.endpoint});
}

class PostRequestGetEvent extends PostRequestEvent {
  final String endpoint;
  const PostRequestGetEvent({required this.endpoint});
}
class PostRequestSendEvent extends PostRequestEvent {
  final String endpoint;
  final Map<String, dynamic> body;
  const PostRequestSendEvent({required this.endpoint, required this.body});
}
class PostRequestFetchElements extends PostRequestEvent {}