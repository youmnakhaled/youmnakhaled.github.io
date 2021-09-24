import 'package:abwab_elkheir_dashboard/ViewModels/AddCaseViewModel.dart';
import 'package:abwab_elkheir_dashboard/ViewModels/AuthenticationViewModel.dart';
import 'package:abwab_elkheir_dashboard/ViewModels/CasesViewModel.dart';
import 'package:abwab_elkheir_dashboard/ViewModels/EditCaseViewModel.dart';
import 'package:abwab_elkheir_dashboard/ViewModels/AddHasadViewModel.dart';
import 'package:abwab_elkheir_dashboard/ViewModels/SettingViewModel.dart';
// import 'package:abwab_elkheir_dashboard/ViewModels/EditCaseViewModel.dart';
import 'package:abwab_elkheir_dashboard/Views/EditCaseScreen.dart';
import 'package:abwab_elkheir_dashboard/Views/AddHasadScreen.dart';
import 'package:abwab_elkheir_dashboard/Views/LandingScreen.dart';
import 'package:abwab_elkheir_dashboard/Views/LayoutTemplate.dart';
import 'package:abwab_elkheir_dashboard/Views/ViewCasesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import 'Views/AddCasesScreen.dart';
import 'Views/SettingsScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  void login(BuildContext context) {
    isLoggedIn = true;
    context.vRouter.push("/cases");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthenticationViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: SettingViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: CasesViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: AddCaseViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: AddHasadViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: EditCaseViewModel(),
        ),
      ],
      child: VRouter(
        mode: VRouterModes.hash,
        title: 'Abwab El Kheir',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.white,
        ),
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar'), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale: Locale('ar'),
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        buildTransition: (animation1, _, child) =>
            FadeTransition(opacity: animation1, child: child),
        routes: [
          VWidget(
            path: '/',
            widget: LandingScreen(onLogin: login),
          ),
          VGuard(
            beforeEnter: (vRedirector) async {
              if (!isLoggedIn) {
                vRedirector.pushReplacement("/");
                print(isLoggedIn);
              }
            },
            stackedRoutes: [
              VWidget(
                path: '/addCase',
                widget: LayoutTemplate(
                  child: AddCaseScreen(),
                ),
              ),
              VWidget(
                path: '/setting',
                widget: LayoutTemplate(
                  child: SettingsScreen(),
                ),
              ),
              VWidget(
                path: '/AddHasad',
                widget: LayoutTemplate(
                  child: AddHasadScreen(),
                ),
              ),
              VWidget(
                path: '/editCase/:id',
                widget: LayoutTemplate(
                  child: EditCaseScreen(),
                ),
              ),
              VWidget(
                path: '/cases',
                widget: LayoutTemplate(
                  child: ViewCasesScreen(),
                ),
              ),
            ],
          ),
          VRouteRedirector(
            path: ':_(.*)',
            redirectTo: '/',
          ),
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
