import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/features/scanning/data/scan_responce.dart';
//import 'scan_result.dart'; // Make sure to import your ScanResult class

class ScanResultWidget extends StatelessWidget {
  //final ScanResult scanResult;
  final String taskName;
  final String taskType;
  ScanResultWidget({/*required this.scanResult*/ required this.taskName, required this.taskType});

  @override
  Widget build(BuildContext context) {
    context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(endpoint: '/$taskType/$taskName'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Result'),
      ),
      body: BlocConsumer<PostRequestBloc, PostRequestState>(
  listener: (context, state) {
    if(state is PostRequestLoadFailureState){
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(state.error, style: TextStyle(color: Colors.redAccent),),
          actions:
          [
            IconButton(onPressed: (){
              ScaffoldMessenger.of(context).clearMaterialBanners();
            },
              icon: Icon(Icons.close),
            ),
          ],
        ),
      );
    }
  },
  builder: (context, state) {
    if(state is PostRequestLoadSingleSuccessState) {
      // ntLogger.e(state.postData);
      final ScanResult scanResult = ScanResult.fromJson(state.postData);
      ntLogger.w(scanResult.general_info.task_name);
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralInfo(scanResult.general_info),
            //_buildDiff(scanResult.diff),
            _buildHosts(scanResult.hosts),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator(),);
    }
  }
),
    );
  }

  Widget _buildGeneralInfo(GeneralInfo generalInfo) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: Colors.blue)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('General Info', /*style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)*/),
          Text('Task Name: ${generalInfo.task_name}'),
          Text('Start: ${generalInfo.start}'),
          Text('End: ${generalInfo.end}'),
          Text('Version: ${generalInfo.version}'),
          Text('Elapsed: ${generalInfo.elapsed} seconds'),
          Text('Summary: ${generalInfo.summary}'),
          Text('Up: ${generalInfo.up}'),
          Text('Down: ${generalInfo.down}'),
          Text('Total: ${generalInfo.total}'),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildHosts(Map<String, Host> hosts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hosts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...hosts.entries.map((entry) {
          Host host = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IP: ${host.ip}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Status: ${host.status}'),
              Text('Ports:'),
              ...host.ports.map((port) => ListTile(
                  title: Text("Port: ${port.port}")/*Text('- Port: ${port.port}, Protocol: ${port.protocol},*/,
                  subtitle: Text("Service: ${port.service}"),
                  trailing: Text("State: ${port.state}")),),
              Text('Vulnerabilities:', style: TextStyle(fontWeight: FontWeight.bold),),
              ...host.vulns.entries.map((vulnEntry) {
                Vulnerability vuln = vulnEntry.value;
                // return Text('CVE-ID: ${vuln.id}, CVSS: ${vuln.cvss}, Description: ${vuln.description}');
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vuln.id, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('CVSS : ${vuln.cvss} = ${vuln.cvss_vector}', style: TextStyle(fontWeight: FontWeight.normal),),
                          Text(
                            'CPE : ${vuln.cpe}', style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          Text('Port : ${vuln.port}'),
                          Text('References : ${vuln.references}'), ///TODO: make link
                          Text('Description : ${vuln.description}'),
                          Text('Solutions : ${vuln.solutions}')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                );
              }),
              SizedBox(height: 16.0),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDiff(Map<String, Diff> diff) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Diff', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...diff.entries.map((entry) {
          Diff diffEntry = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IP: ${entry.key}', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Removed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        ...diffEntry.removed.entries.map((removedEntry) {
                          Vulnerability vuln = removedEntry.value as Vulnerability;
                          ntLogger.i(vuln.description);
                          return Text('- ID: ${vuln.id}, Description: ${vuln.description}');
                        }).toList(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Added', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        ...diffEntry.added.entries.map((addedEntry) {
                          Vulnerability vuln = addedEntry.value as Vulnerability;
                          return Text('- ID: ${vuln.id}, Description: ${vuln.description}');
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          );
        }).toList(),
      ],
    );
  }
}
