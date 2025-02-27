import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/scanning/presentation/widgets/dialog_send_scan_request.dart';
import 'package:net_runner/features/scanning/presentation/widgets/scan_gesture_card.dart';

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
                      const Text(
                        'Сканирования*',
                        //style: AppTheme.lightTheme.textTheme.titleMedium
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: (){
                        Navigator.of(context).pushNamed('/create-scan');
                      }, child: Text('New scan*'))
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      //context.read<WebSocketBloc>().add(WebSocketConnect('ws://192.168.20.140:3001/api/v1/ws'));
                      context.read<PostRequestBloc>().add(PostRequestFetchElements());

                    },
                    icon: const Icon(Icons.refresh),
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
                    if (state.elements.isNotEmpty){
                  ntLogger.i(state.elements.length);
                  return ListView.builder(
                      reverse: true,
                      itemCount: state.elements.length,
                      itemBuilder: (context, index) {
                        final elem = state.elements[index];
                        return ScanGestureCard(
                          item: elem,
                          title: elem["number_task"],
                          status: elem["status"],
                          scanType: elem["type"],
                          completeTime: elem["UpdatedAt"],
                          percent: elem["percent"],
                        );
                      });
                } else {
                      return Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.blue, size: 100),);
                    }
              }),
            )),
          ],
        ),
      ),
    );
  }
}
