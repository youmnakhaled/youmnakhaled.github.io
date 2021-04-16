import 'package:abwab_elkheir_dashboard/Widgets/NavigationBarWidgets/Mobile/NavigationBarMobileWidget.dart';
import 'package:flutter/material.dart';

import 'package:responsive_builder/responsive_builder.dart';

class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({@required this.handleDrawer});
  final Function handleDrawer;
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: NavigationBarMobileWidget(
        handleDrawer: handleDrawer,
      ),
      tablet: NavigationBarMobileWidget(
        handleDrawer: handleDrawer,
      ),
      mobile: NavigationBarMobileWidget(
        handleDrawer: handleDrawer,
      ),
    );
  }
}
