part of 'post_request_bloc.dart';

@immutable
abstract class PostRequestState extends Equatable {
  const PostRequestState();
  @override
  List<Object> get props => [];
}

class PostRequestInitialState extends PostRequestState {}
class PostRequestLoadInProgressState extends PostRequestState {}
class PostRequestNullState extends PostRequestState{}

class PostRequestLoadSuccessState extends PostRequestState {
  final List<dynamic> postData;
  const PostRequestLoadSuccessState(this.postData);
  @override
  List<Object> get props => [postData];
}

class PostRequestLoadFailureState extends PostRequestState {
  final String error;
  const PostRequestLoadFailureState(this.error);

  @override
  List<Object> get props => [];
}