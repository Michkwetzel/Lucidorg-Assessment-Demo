import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.close,
      size: 24,
      color: Color(0xff585858),
    );
  }
}
