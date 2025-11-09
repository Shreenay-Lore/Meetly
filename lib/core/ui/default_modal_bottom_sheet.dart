import 'package:flutter/material.dart';

class DefaultModalBottomSheet extends StatelessWidget {
  final List<Widget> elements;

  const DefaultModalBottomSheet({super.key, required this.elements});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: elements,
      ),
    );
  }
}
