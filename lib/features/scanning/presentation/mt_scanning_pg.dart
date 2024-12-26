import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/features/scanning/presentation/mt_dialog_send_scan_request.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class MtScanningPg extends StatefulWidget {
  const MtScanningPg({super.key});

  @override
  State<MtScanningPg> createState() => _MtScanningPgState();
}

class _MtScanningPgState extends State<MtScanningPg> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сканирование',
                  style: AppTheme.lightTheme.textTheme.titleMedium
                ),
                const MtDialogSendScanRequest(),
                IconButton(onPressed: () => context.read<PostRequestBloc>().add(FetchPostRequestEvent()), icon: Icon(Icons.refresh))
              ],
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
                        return Center(
                          child: ElevatedButton(
                            onPressed: () => context.read<PostRequestBloc>().add(FetchPostRequestEvent()),
                            child: Text('Fetch!',
                            style: AppTheme.lightTheme.textTheme.bodySmall),
                          ),
                        );
                      } else if (state is PostRequestLoadInProgressState) {
                          return Center(child: CircularProgressIndicator());
                      } else if(state is PostRequestLoadSuccessState){
                        return ListView.builder(
                          reverse: true,
                          itemCount: state.postData.length,
                          itemBuilder: (context, index){
                            // final itemName = null;
                            
                            final item = state.postData.keys.elementAt(index);
                            final status = state.postData[item];
                            return ListTile(
                              title: Text('Сканирование: ${item.toString()}', style: GoogleFonts.comfortaa(),),
                              subtitle: Text('Статус: ${status["taskStatus"]} | Процент выполнения: ${status["taskProcent"]}', style: GoogleFonts.comfortaa() ),
                              trailing: Text(''),
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
              ))
          ],
        ),
      ),
    );
  }
}
