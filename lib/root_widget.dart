import 'package:flutter/material.dart';
import 'package:mobile_assessment/modules/home/presentation/home_screen.dart';
import 'package:mobile_assessment/service/providers/employees_provider.dart';
import 'package:provider/provider.dart';

class MobileAssessmentApp extends StatefulWidget {
  final bool isDebug;
  const MobileAssessmentApp({Key? key, this.isDebug = true}) : super(key: key);

  @override
  State<MobileAssessmentApp> createState() => _MobileAssessmentAppState();
}

class _MobileAssessmentAppState extends State<MobileAssessmentApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmployeeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: widget.isDebug,
        home: const HomeScreen(),
      ),
    );
  }
}
