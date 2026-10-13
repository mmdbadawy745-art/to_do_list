import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_list/features/splash/splash_screen.dart';
import 'package:to_do_list/features/home/shared_state.dart';

import 'core/app_colors.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final SharedState _sharedState = SharedState();

  @override
  void dispose() {
    _sharedState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharedStateScope(
      state: _sharedState,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          title: 'appTitle'.tr(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
            iconTheme: const IconThemeData(color: AppColors.primary),
          ),
          home: child,
        ),
        child: const SplashScreen(),
      ),
    );
  }
}