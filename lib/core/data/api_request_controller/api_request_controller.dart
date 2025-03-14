import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';

///TODO: include to project very useful thing
class ApiInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode! ~/ 100 == 2) {
      response.data = jsonDecode(response.data);
      handler.next(response);
    } else {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ntLogger.e(
      "Request error: ${err.response?.statusCode} - ${err.response?.data}",
    );
    handler.next(err);
    super.onError(err, handler);
  }
}

class ApiRequestController {
  ApiEndpoints apiEndpoints;
  late Dio dio;
  Map<String, String> _headers = {
    "Authorization": "",
  };

  ApiRequestController({
    required this.apiEndpoints,
  }) {
    dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 3),
        receiveTimeout: Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(ApiInterceptor());
  }

  Future<Map<String, dynamic>> getRequest({
    required String endpointKey,
    String? queryParams,
  }) async {
    try {
      final response = await dio.getUri(
        apiEndpoints.getUri(endpointKey),
        options: Options(
          headers: _headers,
        ),
      );
      return response.data;
    } catch (e) {
      ntLogger.e(e);
      return {
        "Get Error": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> postRequest({
    required String endpointKey,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await dio.postUri(
        apiEndpoints.getUri(endpointKey),
        options: Options(
          headers: _headers,
        ),
        data: jsonEncode(body),
      );
      return response.data;
    } catch (e) {
      ntLogger.e(e);
      return {
        "Post Error": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteRequest({
    required String endpointKey,
    required String itemId,
  }) async {
    try {
      final response = await dio.postUri(
        apiEndpoints.getUri(endpointKey),
        options: Options(
          headers: _headers,
        ),
      );
      return response.data;
    } catch (e) {
      ntLogger.e(e);
      return {
        "Post Error": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateToken(
      Map<String, dynamic> loginData) async {
    try {
      final response = await dio.postUri(
        apiEndpoints.getUri("login"),
        options: Options(
          headers: _headers,
        ),
        data: jsonEncode(loginData),
      );

      _headers["Authorization"] = response.data["token"];
      return {
        "status": "success",
      };
    } catch (e) {
      ntLogger.e(e);
      return {
        "Post Error": e.toString(),
      };
    }
  }
}

///Next time
// class ApiService {
//   Future<List<Group>> fetchGroups() async {
//     final response = await Dio().get('your_api/groups');
//     return (response.data as List).map((e) => Group.fromJson(e)).toList();
//   }
// }
// class ApiBloc extends Bloc<ApiEvent, ApiState> {
//   final ApiService apiService;
//   final GroupListCubit groupListCubit;
//
//   ApiBloc({required this.apiService, required this.groupListCubit}) : super(ApiInitial()) {
//     on<GetGroupListEvent>(_getGroupList);
//   }
//
//   Future<void> _getGroupList(GetGroupListEvent event, Emitter<ApiState> emit) async {
//     try {
//       final groups = await apiService.fetchGroups();
//       groupListCubit.updateGroups(groups);
//     } catch (e) {
//       emit(ApiError("Ошибка загрузки групп"));
//     }
//   }
// }
// class CubitFactory {
//   static final Map<Type, dynamic> _instances = {};
//
//   static T get<T extends Cubit>() {
//     if (!_instances.containsKey(T)) {
//       _instances[T] = _createInstance<T>();
//     }
//     return _instances[T] as T;
//   }
//
//   static T _createInstance<T>() {
//     if (T == GroupListCubit) return GroupListCubit() as T;
//     if (T == HostListCubit) return HostListCubit() as T;
//     throw Exception("Неизвестный Cubit: $T");
//   }
// }
// List<BlocProvider> createBlocProviders() {
//   return [
//     BlocProvider(create: (_) => ThemeControllerCubit()),
//     BlocProvider(create: (_) => ApiBloc(apiService: ApiService(), groupListCubit: CubitFactory.get<GroupListCubit>())),
//     ...CubitFactory._instances.entries.map((entry) => BlocProvider.value(value: entry.value)).toList(),
//   ];
// }
//runApp(MultiBlocProvider(providers: createBlocProviders(), child: MyApp()));
///Very important
/// on<ApiRequestEvent>((event, emit) async {
//   try {
//     final result = await event.requestFunction();
//     event.updateCubit(result);
//   } catch (e) {
//     emit(ApiError("Ошибка запроса: ${e.toString()}"));
//   }
// });
