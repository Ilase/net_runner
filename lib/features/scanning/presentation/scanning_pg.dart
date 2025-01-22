import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/domain/http_bloc/http_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/scanning/presentation/widgets/dialog_send_scan_request.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/features/scanning/presentation/widgets/gesture_card.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            SizedBox(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Сканирования*',
                        //style: AppTheme.lightTheme.textTheme.titleMedium
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const MtDialogSendScanRequest(), //Кнопка Сканировать
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      //context.read<WebSocketBloc>().add(WebSocketConnect('ws://192.168.20.140:3001/api/v1/ws'));
                      context.read<PostRequestBloc>().add(PostRequestFetchElements());

                    },
                    icon: Icon(Icons.refresh),
                  )
                  // IconButton(
                  //   onPressed: () => context.read<PostRequestBloc>().add(
                  //       PostRequestGetEvent(
                  //           uri: "http://192.168.20.140:3001/api/v1/nmap")),
                  //   icon: const Icon(Icons.refresh),
                  // ),
                ],
              ),
            ),
            Expanded(
                child: BlocListener<WebSocketBloc, WebSocketState>(
              listener: (context, state) {
                if (state is WebSocketMessageState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.toString())));
                }
              },
              child: BlocBuilder<ElementBloc, ElementState>(
                  builder: (content, state) {
                    print(state.elements.length);

                    return ListView.builder(
                      reverse: true,
                      itemCount: state.elements.length,
                      itemBuilder: (context, index){
                        final elem = state.elements[index];
                        return ListTile(
                          leading: Text(elem["ID"].toString()),
                          subtitle: Text(elem["number_task"]),
                          title: Text(elem["CreatedAt"]),
                          trailing: Text(elem["status"]),
                        );

                      }
                    );
              }),
            )),
          ],
        ),
      ),
    );
  }
}
