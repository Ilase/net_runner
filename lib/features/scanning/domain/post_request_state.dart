part of 'post_request_bloc.dart';

@immutable
abstract class PostRequestState extends Equatable {
  const PostRequestState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class PostRequestInitialState extends PostRequestState {}

class PostRequestLoadingState extends PostRequestState {}

class PostRequestLoadedState extends PostRequestState {
  final Map<String, dynamic> jsonDocument;
  const PostRequestLoadedState(this.jsonDocument);

  @override
  // TODO: implement props
  List<Object?> get props => [jsonDocument];
}

class PostRequestErrorState extends PostRequestState{
  final String message;

  const PostRequestErrorState(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}