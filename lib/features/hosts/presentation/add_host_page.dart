import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';

class AddHostPage extends StatefulWidget {
  const AddHostPage({super.key});
  static const String route = '/add-host';

  @override
  State<AddHostPage> createState() => _AddHostPageState();
}

class _AddHostPageState extends State<AddHostPage> {
  List<String> leftResponseList = [];
  List<String> rightResponseList = [];
  Map<String, TextEditingController> hostNameControllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add hosts'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Available hosts'),
                            IconButton(
                              onPressed: () {
                                context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(endpoint: '/ping'));
                                leftResponseList.clear();
                              },
                              icon: Icon(Icons.refresh),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Expanded(
                          child: BlocBuilder<PostRequestBloc, PostRequestState>(
                            builder: (context, state) {
                              if (state is PostRequestLoadSingleSuccessState) {
                                leftResponseList.clear();
                                for (dynamic field in state.postData["activeHosts"]) {
                                  leftResponseList.add(field);
                                }
                                return ListView.builder(
                                  itemCount: leftResponseList.length,
                                  itemBuilder: (builder, index) {
                                    final isAdded = rightResponseList.contains(leftResponseList[index]);
                                    return ListTile(
                                      enabled: !isAdded,
                                      onTap: isAdded
                                          ? null
                                          : () {
                                        setState(() {
                                          rightResponseList.add(leftResponseList[index]);
                                          hostNameControllers[leftResponseList[index]] = TextEditingController();
                                        });
                                      },
                                      title: Text(leftResponseList[index]),
                                      trailing: Icon(isAdded ? Icons.check : Icons.arrow_forward),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Selected hosts'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: rightResponseList.length,
                            itemBuilder: (builder, index) {
                              final host = rightResponseList[index];
                              final controller = hostNameControllers[host];
                              return ListTile(
                                title: Text(host),
                                subtitle: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText: 'Enter host name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_back),
                                onTap: () {
                                  setState(() {
                                    leftResponseList.add(host);
                                    rightResponseList.removeAt(index);
                                    hostNameControllers.remove(host);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _sendHostNames();
              },
              child: Text('Confirm'),
            )
          ],
        ),
      ),
    );
  }

  void _sendHostNames() {
    final hostData = <Map<String, dynamic>>[];

    for (final host in rightResponseList) {
      final controller = hostNameControllers[host];
      final hostName = controller?.text ?? '';
      hostData.add({
        'ip': host,
        'name': hostName,
      });
    }
    for(Map<String,dynamic> mail in hostData){
      context.read<PostRequestBloc>().add(PostRequestSendEvent(
            endpoint: '/host', // Замените на ваш endpoint
            body: {
              "ip" : mail["ip"],
              "name" : mail["name"],
            },
          ));
    }
  }
}
