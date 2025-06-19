import 'package:flutter/material.dart';
import 'package:mobile_assessment/common/sizes.dart';

class EmployeeCard extends StatelessWidget {
  final Widget child;
  const EmployeeCard({
    super.key, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          top: EmSizes.sm),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 3), // Adjust the offset
            ),
          ],
          borderRadius: BorderRadius.circular(
              EmSizes.borderRadiusSm),
          color: Colors.white
      ),
      child: child,
    );
  }
}