import 'package:flutter/material.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final List<OverlayEntry> _snackbars = [];

  void showNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        int index = _snackbars.indexOf(overlayEntry);
        return Positioned(
          bottom: 20 + (index * 90), // Смещение вверх на 90px (высота + отступ)
          right: 20,
          child: Notification(
            message: message,
            onClose: () {
              _removeSnackbar(overlayEntry);
            },
          ),
        );
      },
    );

    _snackbars.add(overlayEntry);
    overlay.insert(overlayEntry);
  }

  void showAnimatedNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        int index = _snackbars.indexOf(overlayEntry);
        return AnimatedNotification(
          message: message,
          index: index,
          onClose: () => _removeSnackbar(overlayEntry),
        );
      },
    );

    _snackbars.add(overlayEntry);
    overlay.insert(overlayEntry);
  }

  void _removeSnackbar(OverlayEntry overlayEntry) {
    if (_snackbars.contains(overlayEntry)) {
      _snackbars.remove(overlayEntry);
      overlayEntry.remove();
    }
  }
}

class Notification extends StatefulWidget {
  final String message;
  final VoidCallback onClose;

  const Notification({Key? key, required this.message, required this.onClose})
      : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationController.forward();

    // Автоматическое скрытие через 3 секунды
    Future.delayed(Duration(seconds: 5), () {
      _hideSnackbar();
    });
  }

  void _hideSnackbar() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 80,
          width: 500,
          margin: EdgeInsets.only(bottom: 10, right: 20),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: 300),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: _hideSnackbar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedNotification extends StatefulWidget {
  final String message;
  final int index;
  final VoidCallback onClose;

  const AnimatedNotification({
    Key? key,
    required this.message,
    required this.index,
    required this.onClose,
  }) : super(key: key);

  @override
  _AnimatedNotificationState createState() => _AnimatedNotificationState();
}

class _AnimatedNotificationState extends State<AnimatedNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Начинаем снизу
      end: Offset(0, 0), // Двигаемся в нормальное положение
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Автоматическое закрытие через 5 секунд
    Future.delayed(Duration(seconds: 5), _hideNotification);
  }

  void _hideNotification() {
    _animationController.reverse().then((_) => widget.onClose());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 20 +
              (widget.index * 90) +
              _slideAnimation.value.dy * 90, // Анимация движения
          right: 20,
          child: child!,
        );
      },
      child: Notification(
        message: widget.message,
        onClose: _hideNotification,
      ),
    );
  }
}
