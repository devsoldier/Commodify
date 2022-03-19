import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/trading_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/wallet_screen.dart';

class NavBar extends StatefulWidget {
  static const routeName = '/navbar';
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List<Map<String, dynamic>> _pages;
  int _selectedPageIndex = 0;
  late String selectedInterval;

  @override
  void initState() {
    _pages = [
      {'page': DashboardScreen(), 'title': 'Dashboard'},
      {'page': TradingScreen(), 'title': 'Trading'},
      {'page': TransactionScreen(), 'title': 'Transaction'},
      {'page': WalletScreen(), 'title': 'Wallet'},
      {'page': ProfileScreen(), 'title': 'Profile'},
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pages[_selectedPageIndex]['title']),
          backgroundColor: Color.fromRGBO(10, 38, 83, 1.0),
        ),
        backgroundColor: Colors.white,
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.graphic_eq, size: 30), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart, size: 30),
                label: 'Trading'),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on_outlined, size: 30),
                label: 'Transaction'),
            BottomNavigationBarItem(
                icon: Icon(Icons.wallet_membership, size: 30), label: 'Wallet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account, size: 30),
                label: 'Profile'),
          ],
          selectedItemColor: Color.fromRGBO(0, 178, 255, 1),
          unselectedItemColor: Colors.white,
          currentIndex: _selectedPageIndex,
          backgroundColor: Color.fromRGBO(9, 51, 116, 1.0),
          onTap: _selectPage,
        ),
      ),
    );
  }
}
