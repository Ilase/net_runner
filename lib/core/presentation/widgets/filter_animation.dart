import 'package:flutter/material.dart';

class FilterAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;

  FilterAnimation({super.key, required this.child, required this.onClose});

  @override
  State<FilterAnimation> createState() => _FilterAnimationState();
}

class _FilterAnimationState extends State<FilterAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
    if (_isDrawerOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Container(
          //height: 500,
          width: 300,
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _offsetAnimation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
