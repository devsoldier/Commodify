import 'package:drc/providers/interval.dart';
import 'package:drc/screens/dashboard_screen.dart';
import 'package:drc/screens/profile_screen.dart';
import 'package:drc/screens/resetpass_screen.dart';
import 'package:drc/screens/trading_screen.dart';
import 'package:drc/screens/wallet_screen.dart';
import 'package:drc/widget/navbar.dart';
import 'package:flutter/material.dart';
// import './screens/graph.dart';
import 'package:flutter/cupertino.dart';
import 'screens/login_screen.dart';
import 'widget/navbar.dart';
import 'package:provider/provider.dart';
import './screens/signup_screen.dart';
import './providers/auth.dart';
// import '../screens/clone.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late String selectedInterval;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: TimeInterval(),
        ),
        // FutureProvider.value(
        //   value: Auth().getbalance(),
        //   initialData: 0,
        // )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CMD',
          theme: ThemeData(
            fontFamily: 'Roboto',
          ),
          home: /* (auth.isAuthenticated != null && auth.isAuthenticated == true)
              ? NavBar()
              // : */
              // NavBar(),
              // Clone(),
              SignUpScreen(),
          // ResetPassScreen(),
          routes: {
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            ResetPassScreen.routeName: (ctx) => ResetPassScreen(),
            NavBar.routeName: (ctx) => NavBar(),
            TradingScreen.routeName: (ctx) => TradingScreen(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            DashboardScreen.routeName: (ctx) => DashboardScreen(),
          },
        ),
      ),
    );
  }
}
