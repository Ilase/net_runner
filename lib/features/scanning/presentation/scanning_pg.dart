import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/core/data/logger.dart';
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
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/create-scan');
                          },
                          child: Text('New scan*'))
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
