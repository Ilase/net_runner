import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:net_runner/features/scanning/data/response_model.dart';

void main() async {
  final elementBloc = ElementBloc();
  // final postRequestBloc = PostRequestBloc(elementBloc);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => PostRequestBloc(elementBloc))
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<PostRequestBloc>()
        .add(const UpdateUriPostRequestEvent(uri: "192.168.20.140:3002"));
    context
        .read<PostRequestBloc>()
        .add(const PostRequestGetSingleTaskEvent(endpoint: "/pentest/TASK-00114"));

    return MaterialApp(
      home: Scaffold(
        body: BlocBuilder<PostRequestBloc, PostRequestState>(
          builder: (builder, state) {
            if (state is PostRequestLoadFailureState) {
              ntLogger.i(state.error);
              return Center(
                child: Text('Fail\n${state.error}'),
              );
            } else if (state is PostRequestLoadSingleSuccessState) {
              ntLogger.w(state.postData.runtimeType);
              final ApiScanResponse requestData =
                  ApiScanResponse(state.postData);
              //ntLogger.i(requestData.hosts.length);
              return Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(requestData.generalInfo.taskName),
                            Text(requestData.generalInfo.version),
                            Text(requestData.generalInfo.summary),
                            Text(requestData.generalInfo.startTime),
                            Text(requestData.generalInfo.endTime),
                            Text(requestData.generalInfo.elapsed),
                            Text(requestData.generalInfo.total.toString()),
                            Text(requestData.generalInfo.up.toString()),
                            Text(requestData.generalInfo.down.toString()),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: requestData.hosts.length,
                        itemBuilder: (builder, index) {
                          ntLogger.t(index);
                          final item = requestData.hosts[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1)
                            ),
                            child: Column(
                              children: [
                                Text(item.ip),
                                Text(item.status),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: item.ports.length,
                                        itemBuilder: (builder, index){
                                          return ListTile(
                                            title: Text(item.ports[index].port.toString()),
                                            subtitle: Text(item.ports[index].protocol),
                                            leading: Text(item.ports[index].service),
                                            trailing: Text(item.ports[index].state),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1)
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: item.ports.length,
                                          itemBuilder: (builder, index){
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1)
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(item.vulns[index].cpe),
                                                  Text(item.vulns[index].cveId),
                                                  Text(item.vulns[index].cvss),
                                                  Text(item.vulns[index].cvssString),
                                                  Text(item.vulns[index].port.toString()),
                                                  Text(item.vulns[index].references),
                                                  Text(item.vulns[index].description),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.question_mark_outlined),
                      onPressed: () {
                        context.read<PostRequestBloc>().add(
                              const PostRequestGetSingleTaskEvent(
                                endpoint: "task/TASK-00114",
                              ),
                            );
                      },
                    ),
                    Text(state.toString()),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
