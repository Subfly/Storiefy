import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  static const String route = "/empty";
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
