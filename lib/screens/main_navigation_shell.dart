import 'package:flutter/material.dart';
import 'wallet_dashboard_screen.dart';
import 'cards_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentTabIndex = 0;

  // The 4 main screens corresponding to bottom nav tabs
  final List<Widget> _screens = const [
    WalletDashboardScreen(),
    CardsScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves the scroll position & state of each tab!
      body: IndexedStack(
        index: _currentTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B1120),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentTabIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white60),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF818CF8)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.credit_card_outlined, color: Colors.white60),
              selectedIcon: Icon(Icons.credit_card_rounded, color: Color(0xFF818CF8)),
              label: 'Cards',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, color: Colors.white60),
              selectedIcon: Icon(Icons.bar_chart_rounded, color: Color(0xFF818CF8)),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: Colors.white60),
              selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF818CF8)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
