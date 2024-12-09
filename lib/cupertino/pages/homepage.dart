import 'package:flutter/cupertino.dart';

class CupertinoHomepage extends StatefulWidget {
  const CupertinoHomepage({super.key});

  @override
  State<CupertinoHomepage> createState() => _CupertinoHomepageState();
}

class _CupertinoHomepageState extends State<CupertinoHomepage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Placeholder();
      },
    );
  }
}
