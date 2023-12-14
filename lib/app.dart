import 'package:flutter/material.dart';
import 'package:machine_test_rearrange/rearrange/presentation/manager/home_controller.dart';
import 'package:machine_test_rearrange/rearrange/presentation/router/app_router.dart';
import 'package:provider/provider.dart';

class RearrangeApp extends StatelessWidget {
  const RearrangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeController>(create: (_) => HomeController())
      ],
      child: MaterialApp.router(
        title: "Rearrange app",
        routerConfig: AppRouter.createRoute(),
      ),
    );
  }
}
