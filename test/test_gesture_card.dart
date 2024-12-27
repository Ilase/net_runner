import 'package:flutter/material.dart';
import 'package:net_runner/features/scanning/presentation/widgets/mt_gesture_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated List Example',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
      ),
      home: AnimatedListExample(),
    );
  }
}

class AnimatedListExample extends StatefulWidget {
  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _counter = 0;

  void _addItem() {
    final newItem = 'Item ${_counter + 1}';
    _items.insert(0, newItem);
    _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 300));
    _counter++;
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildItem(removedItem, animation),
      duration: Duration(milliseconds: 300),
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: MtGestureCard(itemName: item)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated List Example'),
      ),
      body: AnimatedList(
        reverse: false,
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}


// GestureDetector(
// onTap: (){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.runes}')));},
// child: Card(
// elevation: 5,
// margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// child: ListTile(
// title: Text(item),
// trailing: IconButton(
// icon: Icon(Icons.delete, color: Colors.red),
// onPressed: () => _removeItem(_items.indexOf(item)),
// ),
// ),
// ),
// ),
