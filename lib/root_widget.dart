import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_assessment/modules/home/presentation/home_screen.dart';
import 'package:mobile_assessment/service/providers/employees_provider.dart';
import 'package:mobile_assessment/utils/navigation.dart';
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
    return DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => EmployeeProvider(),
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: widget.isDebug,
          ),
        );
      }
    );
  }
}
