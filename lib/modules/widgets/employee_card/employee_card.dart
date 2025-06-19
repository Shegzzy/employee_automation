import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  const ShadowContainer({
    super.key, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.height8),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 3), // Adjust the offset
            ),
          ],
          borderRadius: BorderRadius.circular(
              Dimensions.radius8 - 4),
          color: Colors.white
      ),
      child: child,
    );
  }
}