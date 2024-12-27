import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'post_request_event.dart';
part 'post_request_state.dart';

class PostRequestBloc extends Bloc<PostRequestEvent, PostRequestState> {
  PostRequestBloc() : super(PostRequestInitialState()){
    on<PostRequestEvent>(mapEventToState);
  }


  Future<void> mapEventToState(PostRequestEvent event, Emitter<PostRequestState> emit) async {
    if (event is FetchPostRequestEvent) {
      emit(PostRequestLoadInProgressState());
      try {
        final responce = await http.get(
          Uri.parse('http://192.168.20.140:80/info'),
          headers: {
              "uid":"1378500800859113",
              "token":"3045022100f9e2e5e01ac12458f7c1f7753d1584a3527fc1d17df0466baf61e3de4a61a2c5022009bfe43ac628ac4d0ff55c2098dee5332c64dfbf5b90f500665988f46e87abef"
            }
        );

        if(responce.statusCode == 200){
          final infoData = jsonDecode(responce.body);
          emit(PostRequestLoadSuccessState(infoData));
        } else {
          emit(const PostRequestLoadFailureState('Failed to load data'));
        }
      } catch (e) {
        emit(PostRequestLoadFailureState(e.toString()));
      }
    }
  }
}
