import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tontine_list_screen.dart';
import 'screens/support_screen.dart';
import 'screens/ecosystem_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/payment_screen.dart';
import 'services/pocketbase_service.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PocketBaseService()),
      ],
      child: MaterialApp(
        title: 'PAPO App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreenWrapper(),
          '/home': (context) => const HomeScreen(),
          '/tontines': (context) => const TontineListScreen(),
          '/support': (context) => const SupportScreen(),
          '/ecosystem': (context) => const EcosystemScreen(),
          '/admin': (context) => const AdminDashboard(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/chat') {
            final args = settings.arguments as String;
            return MaterialPageRoute(builder: (context) => ChatScreen(ticketId: args));
          }
          if (settings.name == '/payment') {
            final args = settings.arguments as String;
            return MaterialPageRoute(builder: (context) => PaymentScreen(type: args));
          }
          return null;
        },
      ),
    );
  }
}

class AuthScreenWrapper extends StatelessWidget {
  const AuthScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final pbService = Provider.of<PocketBaseService>(context);
    return pbService.isAuthenticated ? const HomeScreen() : const AuthScreen();
  }
}
