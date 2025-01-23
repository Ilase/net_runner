import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class ScanViewPage extends StatelessWidget {
  ScanViewPage({super.key, required this.taskName});
  String taskName;
  static String route = "/task-view";

  @override
  Widget build(BuildContext context) {
    print(taskName);
    context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(
          endpoint: '/task/${taskName}',
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<PostRequestBloc, PostRequestState>(
        builder: (context, state) {
          if (state is PostRequestLoadFailureState) {
            return Center(
              child: Text('Error: ${state.error}*'),
            );
          } else if (state is PostRequestLoadInProgressState) {
            return CircularProgressIndicator();
          } else if (state is PostRequestLoadSingleSuccessState) {
            //jsonData = state.postData ;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.shadowColor,
                          offset: Offset(0, 2),
                          blurRadius: 3
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Task ID: ' + state.postData["ID"].toString()),
                          Text('Type: ' + state.postData["type"].toString()),
                          Text('Status: ' + state.postData["status"].toString()),
                          Text('CreatedAt: ' + state.postData["CreatedAt"].toString()),
                          Text('UpdatedAt: ' + state.postData["UpdatedAt"].toString()),
                          Text('name: ' + state.postData["name"].toString()),
                          Text('speed: ' + state.postData["params"]["speed"].toString()),
                          Text('ports: ' + state.postData["params"]["ports"].toString()),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else
            return Center(
              child: Text("Unexpected error*"),
            );
        },
      ),
    );
  }
}
