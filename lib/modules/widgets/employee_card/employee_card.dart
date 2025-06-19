import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final Widget child;
  const EmployeeCard({
    super.key, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 8),
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