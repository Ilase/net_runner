import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/features/scanning/data/data_parce.dart';
import 'package:net_runner/features/scanning/data/scan_responce.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class ScanViewPage extends StatelessWidget {
  // final NmapScanResult scanResult;
  static const String route = '/task-view';
  String taskName;
  String taskType;

   ScanViewPage({required this.taskName, required this.taskType});

  @override
  Widget build(BuildContext context) {
    context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(
          endpoint: '/$taskType/$taskName',
        ));
    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
      ),
      body: BlocConsumer<PostRequestBloc, PostRequestState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is PostRequestLoadSingleSuccessState) {
            NmapScanResult scanResult = NmapScanResult.fromJson(state.postData);
            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGeneralInfo(scanResult.generalInfo),
                        SizedBox(height: 16),
                        for (var host in scanResult.hosts)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('IP: ${host.ip}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('Status: ${host.status}'),
                              SizedBox(height: 8),
                              Text('Ports:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              for (var port in host.ports)
                                ListTile(
                                  title: Text(
                                      'Port: ${port.port}, Protocol: ${port.protocol}, Service: ${port.service}, State: ${port.state}'),
                                ),
                              SizedBox(height: 8),
                              if (host.vulnerabilities != null &&
                                  host.vulnerabilities!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Vulnerabilities:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    for (var vuln in host.vulnerabilities!)
                                      ListTile(
                                        title: Text(
                                            'ID: ${vuln.id}, CVSS: ${vuln.cvss}, Port: ${vuln.port}'),
                                        subtitle: Text(
                                            'CPE: ${vuln.cpe}, Description: ${vuln.description}'),
                                      ),
                                  ],
                                )
                              else
                                Text('No vulnerabilities found.'),
                              Divider(),
                            ],
                          ),
                      ],
                    )));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildGeneralInfo(info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Info',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Task Name: ${info.taskName}'),
        Text('Version: ${info.version}'),
        Text('Start Time: ${info.start}'),
        Text('End Time: ${info.end}'),
        Text('Elapsed: ${info.elapsed} seconds'),
        Text('Summary: ${info.summary}'),
        Text('Total Hosts: ${info.total} (Up: ${info.up}, Down: ${info.down})'),
        Divider(),
      ],
    );
  }
}

class ScanViewPageOld extends StatelessWidget {
  ScanViewPageOld({super.key, required this.taskName, required this.taskType});
  String taskName;
  String taskType;
  static String route = "/task-view";

  @override
  Widget build(BuildContext context) {
    ntLogger.i(taskName);
    context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(
          endpoint: '/$taskType/$taskName',
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<PostRequestBloc, PostRequestState>(
            builder: (context, state) {
              if (state is PostRequestLoadFailureState) {
                return Center(
                  child: Text('Error: ${state.error}*'),
                );
              } else if (state is PostRequestLoadInProgressState) {
                return const CircularProgressIndicator();
              } else if (state is PostRequestLoadSingleSuccessState) {
                final nmapResult = NmapResult.fromJson(state.postData);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: AppTheme.lightTheme.shadowColor,
                                    offset: const Offset(0, 2),
                                    blurRadius: 3)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Elapsed: *${nmapResult.generalInfo.elapsed} seconds'),
                                Text(
                                    'Start time: *${nmapResult.generalInfo.start}'),
                                Text(
                                    'End time: *${nmapResult.generalInfo.end}'),
                                Text(
                                    'Summary: *${nmapResult.generalInfo.summary}'),
                                Text(
                                    'Hosts down: *${nmapResult.generalInfo.down}'),
                                Text('Hosts up: *${nmapResult.generalInfo.up}'),
                                Text('Total: *${nmapResult.generalInfo.total}'),
                              ],
                            ),
                          ),
                        ),
                        // Text(nmapResult.hosts[0].ip),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Review'),
                        const SizedBox(
                          height: 10,
                        ),
                        // ListView.builder(
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: nmapResult.hosts.length,
                        //   itemBuilder: (builder, index){
                        //     final itemHost = nmapResult.hosts[index];
                        //
                        //     final String itemPorts = itemHost.ports.map((port) => port.port.toString()).join(', ');
                        //     return Container(
                        //       decoration: BoxDecoration(
                        //         border: Border.all(width: 1)
                        //       ),
                        //       child: Column(
                        //         children: [
                        //           Text(itemHost.ip),
                        //
                        //           Text(''),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // )
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: nmapResult.hosts.length,
                          itemBuilder: (context, index) {
                            final itemHost = nmapResult.hosts[index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 1)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('IP: ${itemHost.ip}'),
                                        Text('Status: ${itemHost.status}'),
                                        const Text('Ports:'),
                                        ...itemHost.ports.map((port) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('  Port: ${port.port}'),
                                                Text(
                                                    '  Protocol: ${port.protocol}'),
                                                Text(
                                                    '  Service: ${port.service}'),
                                                Text('  State: ${port.state}'),
                                                if (port.scripts != null)
                                                  ...port.scripts!
                                                      .map((script) => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '    Script ID: ${script.id}'),
                                                              Text(
                                                                  '    Script Output: ${script.output}'),
                                                            ],
                                                          )),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return const Center(
                  child: Text("Unexpected error*"),
                );
            },
          ),
        ),
      ),
    );
  }
}
