import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/features/scanning/presentation/widgets/mt_dialog_send_scan_request.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/features/scanning/presentation/widgets/mt_gesture_card.dart';

class MtScanningPg extends StatefulWidget {
  const MtScanningPg({super.key});

  @override
  State<MtScanningPg> createState() => _MtScanningPgState();
}

class _MtScanningPgState extends State<MtScanningPg> {
  @override
  Widget build(BuildContext context) {
    context.read<PostRequestBloc>().add(FetchPostRequestEvent());
    return Center(
      child: Container(
        decoration: BoxDecoration(
        ),
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
                  'Сканирования',
                  //style: AppTheme.lightTheme.textTheme.titleMedium
                ),
                const MtDialogSendScanRequest(), //Кнопка Сканировать
                ]
                ),
                 IconButton(onPressed: () => context.read<PostRequestBloc>().add(FetchPostRequestEvent()), icon: Icon(Icons.refresh, size: 30,)),
              ],
            ),
            ),
              Expanded(
                  child: BlocListener<PostRequestBloc, PostRequestState>(
                listener: (context, state){
                  if(state is PostRequestLoadFailureState){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                child: BlocBuilder<PostRequestBloc, PostRequestState>(
                    builder: (content, state){
                      if(state is PostRequestInitialState){
                        return Center(child: CircularProgressIndicator());
                      } else if (state is PostRequestLoadInProgressState) {
                          return Center(child: CircularProgressIndicator());
                      } else if(state is PostRequestLoadSuccessState){
                        return
                          ListView.builder(
                          padding: EdgeInsets.only(right: 15),
                          reverse: true,
                          itemCount: state.postData.length,
                          itemBuilder: (context, index){
                            final item = state.postData.keys.elementAt(index);
                            final status = state.postData[item];
                            return MtGestureCard(
                                title: 'Сканирование: ${item.toString()}',
                                status: status["taskStatus"]
                            );
                          }
                        );
                      } else if (state is PostRequestLoadFailureState){
                        return Center(child: Text('Failure lasd '));
                      } else {
                        return Center(child: Text('Unksnad'));
                      }
                  }
                ),
              )
              ),
          ],
        ),
      ),
    );
  }
}
