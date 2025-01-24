import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';

part 'post_request_event.dart';
part 'post_request_state.dart';

class PostRequestBloc extends Bloc<PostRequestEvent, PostRequestState> {
  final ElementBloc elementBloc;
  static String? uri;
  PostRequestBloc(this.elementBloc) : super(PostRequestInitialState()){
    //on<PostRequestEvent>(mapEventToState);
    on<PostRequestGetEvent>(_getResponse);
    on<PostRequestSendEvent>(_sendRequest);
    on<UpdateUriPostRequestEvent>(_updateUri);
    on<PostRequestFetchElements>(_getTasks);
    on<ClearUriPostRequestEvent>(_clearUri);
    on<PostRequestGetSingleTaskEvent>(_getSingleTask);
  }

  Future<void> _getSingleTask(PostRequestGetSingleTaskEvent event, Emitter emit) async {
    try{
      if (uri == "") {
        emit(PostRequestLoadFailureState("Uri is empty*"));
        return;
      }
      print(uri);
      print(uri! + '/task'+ event.endpoint);
      final response = await http.get(
        Uri.parse(uri! + event.endpoint),
      );

      final decodedResponce = jsonDecode(response.body);
      print(decodedResponce.toString());
      emit(PostRequestLoadSingleSuccessState(decodedResponce));
    }catch(e){
      print(e.toString());
      emit(PostRequestLoadFailureState(e.toString()));
    }
  }

  Future<void> _getTasks(PostRequestFetchElements event, Emitter emit) async {
    if(uri == ""){
      emit(PostRequestLoadFailureState("Uri is empty*"));
      return;
    }
    final response = await http.get(
      Uri.parse(uri! + '/task'),
    );
    final decodedResponce = jsonDecode(response.body);
    //print(decodedResponce);
    // final List<Map<String, dynamic>> fetchedElements = await response as List<Map<String, dynamic>>;
    elementBloc.add(SetElements(List<Map<String,dynamic>>.from(decodedResponce)  /*decodedResponce as List<Map<String, dynamic>>*/));

    
  }

  Future<void> _updateUri(UpdateUriPostRequestEvent event, Emitter emit) async {

      uri = 'http://' + event.uri + '/api/v1';

      print(event.uri);
      print(uri);

  }

  Future<void> _clearUri(ClearUriPostRequestEvent event, Emitter emit) async {
    uri = "";
    print(uri);
    emit(PostRequestNullState());
  }

  Future<void> _sendRequest(PostRequestSendEvent event, Emitter emit) async {
    print(event.body);
    try{
      final responce = await http.post(
        Uri.parse(uri! + event.endpoint),
        body: jsonEncode(event.body)
      );
      // print(responce.body.toString());
      emit(PostRequestLoadSingleSuccessState(jsonDecode(responce.body)));
    } catch (e){
      // print("POST BLOC " + e.toString());
      emit(PostRequestLoadFailureState(e.toString()));
    }
  }
  Future<void> _getResponse(PostRequestGetEvent event, Emitter emit) async {
    emit(PostRequestLoadInProgressState());
    try{
      final responce = await http.get(
        Uri.parse(uri! + event.endpoint),
      );

      if(responce.statusCode == 200){
        final infoData = await jsonDecode(responce.body) as List<dynamic>;
        emit(PostRequestLoadSuccessState(infoData));
      } else {
        PostRequestLoadFailureState('Failed to load data. ${responce.statusCode} *');
      }

    } catch (e){
      emit(PostRequestLoadFailureState('Failed to load data: ${e.toString()} *'));
    }

    @override
    Future<void> close() {
      uri = "";
      return super.close();
    }
  }
  // Future<void> mapEventToState(PostRequestEvent event, Emitter<PostRequestState> emit) async {
  //   if (event is FetchPostRequestEvent) {
  //     emit(PostRequestLoadInProgressState());
  //     try {
  //       final responce = await http.get(
  //         Uri.parse('http://192.168.20.140:80/info'),
  //         headers: {
  //             "uid":"1378500800859113",
  //             "token":"3045022100f9e2e5e01ac12458f7c1f7753d1584a3527fc1d17df0466baf61e3de4a61a2c5022009bfe43ac628ac4d0ff55c2098dee5332c64dfbf5b90f500665988f46e87abef"
  //           }
  //       );
  //
  //       if(responce.statusCode == 200){
  //         final infoData = jsonDecode(responce.body);
  //         emit(PostRequestLoadSuccessState(infoData));
  //       } else {
  //         emit(const PostRequestLoadFailureState('Unexpected failure *'));
  //       }
  //     } catch (e) {
  //       emit(PostRequestLoadFailureState(e.toString()));
  //     }
  //   }
  // }
}
