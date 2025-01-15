import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/scanning/presentation/widgets/mt_dialog_send_scan_request.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/features/scanning/presentation/widgets/mt_gesture_card.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/features/scanning/presentation/widgets/filter.dart';
import 'package:net_runner/core/presentation/widgets/filter_animation.dart';

class MtScanningPg extends StatefulWidget {
  const MtScanningPg({super.key});

  @override
  State<MtScanningPg> createState() => _MtScanningPgState();
}

class _MtScanningPgState extends State<MtScanningPg> {
  bool _isFilterOpen = false;

  void _toggleFilter() {
    setState(() {
      _isFilterOpen = !_isFilterOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.scanningRailDestination,
                            //style: AppTheme.lightTheme.textTheme.titleMedium
                          ),
                          const MtDialogSendScanRequest(), //Кнопка Сканировать
                        ],
                      ),
                      IconButton(
                        onPressed: _toggleFilter,
                        icon: Icon(Icons.filter_alt),
                      ),
                      IconButton(
                        onPressed: () => context.read<PostRequestBloc>().add(FetchPostRequestEvent()),
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocListener<WebSocketBloc, WebSocketState>(
                    listener: (context, state) {
                      if (state is PostRequestLoadFailureState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.toString())));
                      }
                    },
                    child: BlocBuilder<PostRequestBloc, PostRequestState>(
                      builder: (context, state) {
                        if (state is PostRequestInitialState) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () => context.read<PostRequestBloc>().add(FetchPostRequestEvent()),
                              child: Text('Fetch!',
                                  style: AppTheme.lightTheme.textTheme.bodySmall),
                            ),
                          );
                        } else if (state is PostRequestLoadInProgressState) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is PostRequestLoadSuccessState) {
                          return ListView.builder(
                            padding: EdgeInsets.only(right: 15),
                            reverse: true,
                            itemCount: state.postData.length,
                            itemBuilder: (context, index) {
                              final item = state.postData.keys.elementAt(index);
                              final status = state.postData[item];
                              return MtGestureCard(
                                title: 'Сканирование: ${item.toString()}',
                                status: status["taskStatus"],
                              );
                            },
                          );
                        } else if (state is PostRequestLoadFailureState) {
                          return const Center(child: Text('Failure lasd '));
                        } else {
                          return const Center(child: Text('Unksnad'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_isFilterOpen)
              FilterAnimation(
                onClose: _toggleFilter,
                child: Filter(onClose: _toggleFilter),
              ),
          ],
        ),
      ),
    );
  }
}
