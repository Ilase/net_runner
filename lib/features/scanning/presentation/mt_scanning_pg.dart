import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/scanning/presentation/mt_dialog_send_scan_request.dart';

class MtScanningPg extends StatefulWidget {
  const MtScanningPg({super.key});

  @override
  State<MtScanningPg> createState() => _MtScanningPgState();
}

class _MtScanningPgState extends State<MtScanningPg> {
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    context.read<WebSocketBloc>().add(WebSocketConnect('ws://192.168.20.140/scan'));
  }

  @override
  void dispose() {
    context.read<WebSocketBloc>().add(WebSocketDisconnect());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // final WebSocketBloc bloc = WebSocketBloc();
    return BlocProvider<WebSocketBloc>(
      create: (context) => WebSocketBloc(),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сканирование',
                  style: GoogleFonts.comfortaa(
                    fontSize: 32,
                    color: Colors.blue,
                  ),
                ),
                const MtDialogSendScanRequest(),
              ],
            ),
            BlocListener<WebSocketBloc, WebSocketState>(
              listener: (context, state) {
                if(state is WebSocketMessageState){
                  setState(() {
                    messages.add(state.message);
                  });
                }
              },
              child: Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(),
                          child: Text(messages[index])
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
