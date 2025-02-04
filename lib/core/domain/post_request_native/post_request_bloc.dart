import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'dart:convert';
// import 'package:web/web.dart' as web;
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';

part 'post_request_event.dart';
part 'post_request_state.dart';


//TODO: browser client

class PostRequestBloc extends Bloc<PostRequestEvent, PostRequestState> {
  final ElementBloc elementBloc;

  static String? uri;

  PostRequestBloc(this.elementBloc) : super(PostRequestInitialState()){
    //on<PostRequestEvent>(mapEventToState);
    on<PostRequestGetEvent>(_getResponseOls);
    on<PostRequestSendEvent>(_sendRequest);
    on<UpdateUriPostRequestEvent>(_updateUri);
    on<PostRequestFetchElements>(_getTasks);
    on<ClearUriPostRequestEvent>(_clearUri);
    on<PostRequestGetSingleTaskEvent>(_getSingleTask);
  }

  Future<void> _getSingleTask(PostRequestGetSingleTaskEvent event, Emitter emit) async {
    try{
      if (uri == "") {
        emit(const PostRequestLoadFailureState("Uri is empty*"));
        return;
      }
      // final response =
      ntLogger.i(uri);
      ntLogger.i('${uri!}/task${event.endpoint}');
      final response = await http.get(
        Uri.parse(uri! + event.endpoint),
      );

      final decodedResponce = jsonDecode(response.body);
      if(response.statusCode == 200) {
        ntLogger.i('Responce$decodedResponce');
      } else {
        ntLogger.i('Request failed');
      }

      emit(PostRequestLoadSingleSuccessState(decodedResponce));
    }catch(e){
      ntLogger.e(e.toString());
      emit(PostRequestLoadFailureState(e.toString()));
    }
  }

  Future<void> _getTasks(PostRequestFetchElements event, Emitter emit) async {
    if(uri == ""){
      emit(const PostRequestLoadFailureState("Uri is empty*"));
      return;
    }
    final response = await http.get(
      Uri.parse('${uri!}/task'),
    );
    final decodedResponce = jsonDecode(response.body);
    //print(decodedResponce);
    // final List<Map<String, dynamic>> fetchedElements = await response as List<Map<String, dynamic>>;
    elementBloc.add(SetElements(List<Map<String,dynamic>>.from(decodedResponce)  /*decodedResponce as List<Map<String, dynamic>>*/));

    
  }

  Future<void> _updateUri(UpdateUriPostRequestEvent event, Emitter emit) async {
      uri = 'http://${event.uri}/api/v1';
      ntLogger.i(uri);
  }

  Future<void> _clearUri(ClearUriPostRequestEvent event, Emitter emit) async {
    uri = "";
    ntLogger.i(uri);
    emit(PostRequestNullState());
  }

  Future<void> _sendRequest(PostRequestSendEvent event, Emitter emit) async {
    ntLogger.i(event.body);
    try{
      final responce = await http.post(
        Uri.parse(uri! + event.endpoint),
        body: jsonEncode(event.body)
      );
      emit(PostRequestLoadSingleSuccessState(jsonDecode(responce.body)));
    } catch (e){
      ntLogger.e(e.toString());
      emit(PostRequestLoadFailureState(e.toString()));
    }
  }
  Future<void> _getResponseOls(PostRequestGetEvent event, Emitter emit) async {
    emit(PostRequestLoadInProgressState());
    try{
      final response = await http.get(
        Uri.parse(uri! + event.endpoint),
      );

      if(response.statusCode == 200){
        final infoData = await jsonDecode(response.body) as List<dynamic>;
        emit(PostRequestLoadSuccessState(infoData));
      } else {
        ntLogger.e(response.statusCode);
        PostRequestLoadFailureState('Failed to load data. ${response.statusCode} *');
      }

    } catch (e){
      emit(PostRequestLoadFailureState('Failed to load data: ${e.toString()} *'));
    }

  }
}
