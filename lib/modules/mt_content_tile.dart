import 'package:flutter/material.dart';

class MtContentTile extends StatefulWidget {
  const MtContentTile({super.key});

  @override
  State<MtContentTile> createState() => _MtContentTileState();
}

class _MtContentTileState extends State<MtContentTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimations() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _toggleAnimations,
        child: SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Title',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                if (_isExpanded)
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'This is the description that appears when the container is expanded.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
