/// Point d'entrée de l'application Papo
/// 
/// Cette application est un portefeuille électronique complet avec :
/// - Authentification sécurisée (Phone + PIN + Biométrie)
/// - Gestion de portefeuille multi-devises
/// - Transactions online et offline (NFC, QR, Bluetooth)
/// - Système de tontines (cercles d'épargne)
/// - Support client 24/7
/// - Écosystème de services
/// - Panel administrateur web

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/pocketbase_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les préférences partagées
  await SharedPreferences.getInstance();
  
  runApp(const PapoApp());
}

class PapoApp extends StatefulWidget {
  const PapoApp({Key? key}) : super(key: key);

  @override
  State<PapoApp> createState() => _PapoAppState();
}

class _PapoAppState extends State<PapoApp> {
  late PocketBaseService _pbService;
  bool _isInitialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _pbService = PocketBaseService();
      await _pbService.init();
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _initError = 'Erreur d\'initialisation: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: _initError != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_initError!),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isInitialized = false;
                            _initError = null;
                          });
                          _initializeApp();
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Initialisation de Papo...'),
                    ],
                  ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PocketBaseService>.value(value: _pbService),
      ],
      child: MaterialApp(
        title: 'Papo - Portefeuille Électronique',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: _pbService.isAuthenticated 
            ? const HomeScreen() 
            : const AuthScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _pbService.dispose();
    super.dispose();
  }
}

// ============================================================================
// ÉCRAN D'AUTHENTIFICATION (PLACEHOLDER)
// ============================================================================

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wallet, size: 80, color: Color(0xFF2563EB)),
            const SizedBox(height: 24),
            Text(
              'Papo',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Portefeuille Électronique',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // TODO: Implémenter la connexion
              },
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // TODO: Implémenter l'inscription
              },
              child: const Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ÉCRAN D'ACCUEIL (PLACEHOLDER)
// ============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pbService = Provider.of<PocketBaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Afficher les notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Ouvrir les paramètres
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Color(0xFF10B981)),
            const SizedBox(height: 24),
            Text(
              'Bienvenue dans Papo!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            if (pbService.currentUser != null)
              Text(
                'Utilisateur: ${pbService.currentUser!.name}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                await pbService.logout();
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Envoyer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tontines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Support',
          ),
        ],
      ),
    );
  }
}
