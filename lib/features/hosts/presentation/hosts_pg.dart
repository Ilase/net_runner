import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class MtHostsPg extends StatefulWidget {
  const MtHostsPg({super.key});

  @override
  State<MtHostsPg> createState() => _MtHostsPgState();
}

class _MtHostsPgState extends State<MtHostsPg> {
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
