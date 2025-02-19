import 'package:flutter/material.dart';

class HostsPg extends StatefulWidget {
  const HostsPg({super.key});

  @override
  State<HostsPg> createState() => _HostsPgState();
}

class _HostsPgState extends State<HostsPg> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Хосты и группы'),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 60,
                              color: Colors.grey),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration:
                                        InputDecoration(labelText: 'Поиск'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.search),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        boxShadow: [],
                      ),
                      child: Placeholder(),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
