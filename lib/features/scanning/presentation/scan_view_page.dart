import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class ScanViewPage extends StatelessWidget {
  ScanViewPage({super.key, required this.jsonData});
  Map<String, dynamic> jsonData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScanName*'),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: PageView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                blurRadius: 3,
                              )
                            ]),
                        child: Column(
                          children: [
                            Text('Scan info: *'),
                            Text(
                              '${jsonData["general_info"]["start"]}',
                            ),
                            Text(
                              '${jsonData["general_info"]["end"]}',
                            ),
                            Text(
                              '${jsonData["general_info"]["elapsed"]} minutes *',
                            ),
                            Text('${jsonData["general_info"]["summary"]}'),
                            Text('${jsonData["general_info"]["up"]}'),
                            Text('${jsonData["general_info"]["down"]}'),
                            Text('${jsonData["general_info"]["total"]}'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Details',
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, builder) {
              return ListTile();
            },
          )
        ],
      ),
    );
  }
}
