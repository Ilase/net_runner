import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
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
                if (state is PostRequestLoadFailureState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.toString())));
                }
              },
              child: BlocBuilder<WebSocketBloc, WebSocketState>(
                  builder: (content, state) {

                    if(state is WebSocketMessageReceived){
                      return Center(child: Text('data'),);
                    } else if (state is WebSocketConnected) {
                      return Text(state.taskList.toString());
                        // return ListView.builder(
                        //   itemCount: state.taskList.length,
                        //   reverse: true,
                        //   itemBuilder: (context, index){
                        //     final item = state.taskList.elementAt(index);
                        //    
                        //     // return MtGestureCard(
                        //     //     title: item["number_task"],
                        //     //     status: item["status"],
                        //     // );
                        //   }
                        // );
                    } else {
                      return CircularProgressIndicator();
                    }
                // if (state is WebSocketException) {
                //   return Center(
                //     child: Text(
                //       'Can\'t get data from server, try to refresh connection',
                //     ),
                //   );

                // } else if (state is PostRequestLoadSuccessState) {
                //   // return ListView.builder(
                //   //   padding: EdgeInsets.only(right: 15),
                //   //   reverse: true,
                //   //   itemCount: state.postData.length,
                //   //   itemBuilder: (context, index) {
                //   //     final item = state.postData.keys.elementAt(index);
                //   //     final status = state.postData[item];
                //   //     return MtGestureCard(
                //   //         title: 'Сканирование: ${item.toString()}',
                //   //         status: status["taskStatus"]);
                //   //     //   ListTile(
                //   //     //   title: Text('Сканирование: ${item.toString()}', style: AppTheme.lightTheme.textTheme.titleMedium),
                //   //     //   subtitle: Text('Статус: ${status["taskStatus"]} | Процент выполнения: ${status["taskProcent"]}', style: GoogleFonts.comfortaa() ),
                //   //     //   trailing: Text(''),
                //   //     // );
                //   //   },
                //   // );
                //   return CircularProgressIndicator();
                // } else if (state is PostRequestLoadFailureState) {
                //   return Center(child: Text('Loading failure. *'));
                // } else {
                //   return const Center(child: Text('Undefined state *'));
                // }
              }),
            )),
          ],
        ),
      ),
    );
  }
}
