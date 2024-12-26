// import 'dart:convert';
//
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;
// part '../lib/features/scanning/domain/post_request_event.dart';
// part '../lib/features/scanning/domain/post_request_state.dart';
//
// class PostRequestBloc extends Bloc<PostRequestEvent, PostRequestState> {
//   PostRequestBloc() : super(PostRequestInitialState()) {
//     on<SendPostRequestEvent>(_onSendRequest);
//   }
//
//   Future<void> _onSendRequest(SendPostRequestEvent event, Emitter<PostRequestState> emit) async {
//     emit(PostRequestLoadingState());
//     try {
//       final response = await http.post(
//         Uri.parse(event.url),
//         body: jsonEncode(event.body),
//         headers: event.headers,
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         emit(PostRequestLoadedState(jsonResponse));
//       } else {
//         emit(const PostRequestErrorState('failed to load response'));
//       }
//     } catch(e) {
//       emit(PostRequestErrorState(e.toString()));
//     }
//   }
// }
