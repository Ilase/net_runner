import 'package:flutter/material.dart';

class MtNavigationRail extends StatefulWidget {
  const MtNavigationRail({super.key});

  @override
  State<MtNavigationRail> createState() => _MtNavigationRailState();
}

class _MtNavigationRailState extends State<MtNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 6),
              color: Colors.black26,
              blurRadius: 2,
            )
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.radar_outlined)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.document_scanner_outlined))
          ],
        ),
      ),
    );
  }
}
