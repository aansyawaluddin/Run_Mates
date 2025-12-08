import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/component/navbar.dart';
import 'package:runmates/page/main/home.dart';
import 'package:runmates/page/main/profile.dart';
import 'package:runmates/page/main/programWeek.dart';
import 'package:runmates/providers/navigation_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          extendBody: true,
          body: PageView(
            controller: navProvider.pageController,
            onPageChanged: navProvider.onPageChanged,
            children: const [HomePage(), ProgramWeekPage(), ProfilePage()],
          ),
          bottomNavigationBar: CustomBottomNav(
            currentIndex: navProvider.currentIndex,
            onTap: navProvider.onTapNav,
          ),
        );
      },
    );
  }
}
