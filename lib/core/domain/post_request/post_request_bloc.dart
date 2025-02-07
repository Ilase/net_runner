import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'dart:convert';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';

part 'post_request_event.dart';
part 'post_request_state.dart';

class PostRequestBloc extends Bloc<PostRequestEvent, PostRequestState> {
  final ElementBloc elementBloc;

  static String? uri;

  PostRequestBloc(this.elementBloc) : super(PostRequestInitialState()){
    on<PostRequestGetEvent>(_getResponseOls);
    on<PostRequestSendEvent>(_sendRequest);
    on<UpdateUriPostRequestEvent>(_updateUri);
    on<PostRequestFetchElements>(_getTasks);
    on<ClearUriPostRequestEvent>(_clearUri);
    on<PostRequestGetSingleTaskEvent>(_getSingleTask);
    on<PostRequestDeleteHostEvent>(_deleteHost);
  }

  Future<void> _getSingleTask(PostRequestGetSingleTaskEvent event, Emitter emit) async {
    emit(PostRequestLoadInProgressState());
    try{
      if (uri == "") {
        emit(const PostRequestLoadFailureState("Uri is empty*"));
        return;
      }
      ntLogger.i(uri);
      ntLogger.i('${uri!}' '${event.endpoint}');
      final response = await http.get(
        Uri.parse(uri! + event.endpoint),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        ntLogger.i('Response\n$decodedResponse');
        emit(PostRequestLoadSingleSuccessState(decodedResponse));
      } else {
        ntLogger.i('Request failed: status code ${response.statusCode}');
        emit(PostRequestLoadFailureState('Request failed: status code ${response.statusCode}'));
      }
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
    final decodedResponse = jsonDecode(response.body);
    elementBloc.add(SetElements(List<Map<String,dynamic>>.from(decodedResponse)));
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
      ntLogger.w(uri! + event.endpoint);
      http.Response response = await http.post(
        Uri.parse(uri! + event.endpoint),
        body: jsonEncode(event.body),
        headers: {'Content-Type': 'application/json'},
      );

      ntLogger.i('Response status: ${response.statusCode}');
      ntLogger.i('Response body: ${response.body}');

      while (response.statusCode == 307) {
        final newUri = response.headers['location'];
        if (newUri == null) {
          ntLogger.e('No location header in 307 response');
          emit(const PostRequestLoadFailureState('No location header in 307 response'));
          return;
        }
        response = await http.post(
          Uri.parse(newUri),
          body: jsonEncode(event.body),
          headers: {'Content-Type': 'application/json'},
        );
        ntLogger.i('Redirection response status: ${response.statusCode}');
        ntLogger.i('Redirection response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final decodedResponse = jsonDecode(response.body);
          ntLogger.i('Response\n$decodedResponse');
          emit(PostRequestLoadSingleSuccessState(decodedResponse));
        } else {
          ntLogger.e('Empty response body');
          emit(PostRequestLoadFailureState('Empty response body'));
        }
      } else {
        ntLogger.i('Request failed: status code ${response.statusCode}');
        emit(PostRequestLoadFailureState('Request failed: status code ${response.statusCode}'));
      }
    } catch (e) {
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
        emit(PostRequestLoadFailureState('Failed to load data. ${response.statusCode} *'));
      }
    } catch (e){
      emit(PostRequestLoadFailureState('Failed to load data: ${e.toString()} *'));
    }
  }

  Future<void> _deleteHost(PostRequestDeleteHostEvent event, Emitter emit) async {
    try{
      final response = http.delete(
        Uri.parse(uri! + '/host/${event.hostId}'),
      );
    } catch(e){
      ntLogger.e(e);
    }
  }

}
