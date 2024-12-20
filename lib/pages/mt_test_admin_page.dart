import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:net_runner/modules/mt_dialog_tile.dart';

class MtTestAdminPage extends StatefulWidget {
  const MtTestAdminPage({super.key});

  @override
  State<MtTestAdminPage> createState() => _MtTestAdminPageState();
}

class _MtTestAdminPageState extends State<MtTestAdminPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Test Admin Page',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Column(
            children: [
              MTOpenDialogButton(
                child: const Column(),
              )
            ],
          )
        ]),
      ),
    );
  }
}
