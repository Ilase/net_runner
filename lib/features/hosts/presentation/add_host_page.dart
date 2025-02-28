import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:net_runner/core/data/ip_input_formatter.dart';

class AddHostPage extends StatefulWidget {
  const AddHostPage({super.key});
  static const String route = '/add-host';

  @override
  State<AddHostPage> createState() => _AddHostPageState();
}

class _AddHostPageState extends State<AddHostPage> {
  final TextEditingController _customIpController = TextEditingController();
  final _ipInputFormater = MaskTextInputFormatter(
    mask: '###.###.###.###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
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
                              onPressed: () {},
                              icon: Icon(Icons.refresh),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _customIpController,
                                  inputFormatters: [
                                    IPTextInputFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'By manual',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      rightResponseList
                                          .add(_customIpController.text);
                                      hostNameControllers[_customIpController
                                          .text] = TextEditingController();
                                    });
                                  },
                                  icon: Icon(Icons.accessible))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                                      borderSide:
                                          BorderSide(color: Colors.blue),
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
                setState(() {
                  rightResponseList.clear();
                });
                Navigator.of(context).pop();
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
    for (Map<String, dynamic> mail in hostData) {}
  }
}
