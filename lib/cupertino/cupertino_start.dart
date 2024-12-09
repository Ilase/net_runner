import 'package:flutter/cupertino.dart';

class CupertinoEnv extends StatelessWidget {
  const CupertinoEnv({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        routes: {},
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Cupertino Page'),
          ),
          child: Center(
              child: CupertinoButton.filled(
                  onPressed: null, child: Text('BUTTON'))),
        ));
  }
}
