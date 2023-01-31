import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InvisibleNavigateComponent extends StatelessWidget {
  final Function() onTap;

  const InvisibleNavigateComponent({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.4,
        height: height * 0.7,
        color: Colors.transparent,
      ),
    );
  }
}
