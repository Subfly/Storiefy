import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class RestartableWidget extends StatefulWidget {
  final Widget child;

  const RestartableWidget({
    super.key,
    required this.child,
  });

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartableWidgetState>()?.restartApp();
  }

  @override
  State<RestartableWidget> createState() => _RestartableWidgetState();
}

class _RestartableWidgetState extends State<RestartableWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
