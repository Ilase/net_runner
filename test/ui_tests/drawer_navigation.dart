import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerExpanded = false;
  int selectedPageIndex = 0;

  final List<Widget> pages = [
    Center(child: Text("Страница 1", style: TextStyle(fontSize: 24))),
    Center(child: Text("Страница 2", style: TextStyle(fontSize: 24))),
    Center(child: Text("Страница 3", style: TextStyle(fontSize: 24))),
    Center(child: Text("Страница 4", style: TextStyle(fontSize: 24))),
    Center(child: Text("Страница 5", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            width:
                isDrawerExpanded ? MediaQuery.of(context).size.width / 6 : 100,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(border: Border.all(width: 2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: List.generate(pages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedCrossFade(
                        firstChild: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPageIndex = index;
                            });
                          },
                          child: Text("Страница ${index + 1}"),
                        ),
                        secondChild: IconButton(
                          icon: Icon(Icons.circle, size: 50),
                          onPressed: () {
                            setState(() {
                              selectedPageIndex = index;
                            });
                          },
                        ),
                        crossFadeState: isDrawerExpanded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  }),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isDrawerExpanded = !isDrawerExpanded;
                      });
                    },
                    icon: Icon(Icons.menu),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selectedPageIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
