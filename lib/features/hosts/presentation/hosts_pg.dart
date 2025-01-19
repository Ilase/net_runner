import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class HostsPg extends StatefulWidget {
  const HostsPg({super.key});

  @override
  State<HostsPg> createState() => _HostsPgState();
}

class _HostsPgState extends State<HostsPg> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hosts*',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
