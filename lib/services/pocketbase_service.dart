/// Service PocketBase pour l'application Papo
/// 
/// Ce service gère toutes les interactions avec le backend PocketBase,
/// incluant l'authentification, les transactions, les tontines, etc.
/// 
/// Utilisation :
/// ```dart
/// final pbService = PocketBaseService();
/// await pbService.init();
/// await pbService.login(phone, pin);
/// ```

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/pocketbase_config.dart';
import '../models/models.dart';

class PocketBaseService extends ChangeNotifier {
  late final PocketBase _pb;
  late final FlutterSecureStorage _secureStorage;

  User? _currentUser;
  Wallet? _currentWallet;
  bool _isInitialized = false;

  // Getters
  User? get currentUser => _currentUser;
  Wallet? get currentWallet => _currentWallet;
  bool get isAuthenticated => _pb.authStore.isValid;
  bool get isInitialized => _isInitialized;
  String? get authToken => _pb.authStore.token;

  /// Initialiser le service PocketBase
  Future<void> init() async {
    try {
      _pb = PocketBase(PocketBaseConfig.pbUrl);
      _secureStorage = const FlutterSecureStorage();

      // Charger le token stocké
      final savedToken = await _secureStorage.read(key: 'auth_token');
      if (savedToken != null && savedToken.isNotEmpty) {
        _pb.authStore.save(savedToken, null);
      }

      // Configurer les intercepteurs
      _setupInterceptors();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation PocketBase: $e');
      rethrow;
    }
  }

  /// Configurer les intercepteurs
  void _setupInterceptors() {
    _pb.beforeSend = (url, config) async {
      // Ajouter les headers personnalisés si nécessaire
      return config;
    };

    _pb.afterSend = (response, request) async {
      // Gérer les erreurs de réponse
      return response;
    };
  }

  // ========================================================================
  // AUTHENTIFICATION
  // ========================================================================

  /// Inscription d'un nouvel utilisateur
  Future<User> signup({
    required String phone,
    required String pin,
    required String name,
    String? email,
  }) async {
    try {
      final body = {
        'phone': phone,
        'password': pin,
        'passwordConfirm': pin,
        'name': name,
        'email': email,
        'user_type': 'individual',
        'is_active': true,
        'theme_preference': 'system',
        'language': 'fr',
      };

      final record = await _pb.collection(PocketBaseConfig.collectionUsers).create(body: body);
      _currentUser = User.fromJson(record.toJson());

      // Créer un portefeuille par défaut
      await _createDefaultWallet(_currentUser!.id);

      notifyListeners();
      return _currentUser!;
    } catch (e) {
      debugPrint('Erreur lors de l\'inscription: $e');
      rethrow;
    }
  }

  /// Connexion utilisateur
  Future<User> login(String phone, String pin) async {
    try {
      final authData = await _pb.collection(PocketBaseConfig.collectionUsers).authWithPassword(phone, pin);

      if (authData.record == null) {
        throw Exception('Erreur d\'authentification');
      }

      _currentUser = User.fromJson(authData.record!.toJson());

      // Sauvegarder le token
      await _secureStorage.write(
        key: 'auth_token',
        value: _pb.authStore.token,
      );

      // Charger le portefeuille
      await _loadWallet();

      // Mettre à jour le dernier login
      await _updateLastLogin();

      notifyListeners();
      return _currentUser!;
    } catch (e) {
      debugPrint('Erreur lors de la connexion: $e');
      rethrow;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    try {
      _pb.authStore.clear();
      await _secureStorage.delete(key: 'auth_token');
      _currentUser = null;
      _currentWallet = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  /// Vérifier si le token est valide et le rafraîchir si nécessaire
  Future<bool> refreshToken() async {
    try {
      if (!isAuthenticated) {
        return false;
      }

      final authData = await _pb.collection(PocketBaseConfig.collectionUsers).authRefresh();
      if (authData.record != null) {
        _currentUser = User.fromJson(authData.record!.toJson());

        // Sauvegarder le nouveau token
        await _secureStorage.write(
          key: 'auth_token',
          value: _pb.authStore.token,
        );

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors du rafraîchissement du token: $e');
      return false;
    }
  }

  /// Mettre à jour le dernier login
  Future<void> _updateLastLogin() async {
    try {
      if (_currentUser == null) return;

      await _pb.collection(PocketBaseConfig.collectionUsers).update(
        _currentUser!.id,
        body: {
          'last_login': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du dernier login: $e');
    }
  }

  // ========================================================================
  // PORTEFEUILLE
  // ========================================================================

  /// Créer un portefeuille par défaut
  Future<void> _createDefaultWallet(String userId) async {
    try {
      await _pb.collection(PocketBaseConfig.collectionWallets).create(
        body: {
          'user': userId,
          'balance': 0.0,
          'currency': PocketBaseConfig.defaultCurrency,
          'daily_limit': PocketBaseConfig.defaultDailyLimit,
          'monthly_limit': PocketBaseConfig.defaultMonthlyLimit,
          'is_active': true,
        },
      );
    } catch (e) {
      debugPrint('Erreur lors de la création du portefeuille: $e');
    }
  }

  /// Charger le portefeuille de l'utilisateur
  Future<void> _loadWallet() async {
    try {
      if (_currentUser == null) return;

      final record = await _pb.collection(PocketBaseConfig.collectionWallets).getFirstListItem(
        'user = "${_currentUser!.id}"',
      );

      _currentWallet = Wallet.fromJson(record.toJson());
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement du portefeuille: $e');
    }
  }

  /// Obtenir le portefeuille
  Future<Wallet?> getWallet() async {
    try {
      if (_currentUser == null) return null;

      final record = await _pb.collection(PocketBaseConfig.collectionWallets).getFirstListItem(
        'user = "${_currentUser!.id}"',
      );

      return Wallet.fromJson(record.toJson());
    } catch (e) {
      debugPrint('Erreur lors de la récupération du portefeuille: $e');
      return null;
    }
  }

  // ========================================================================
  // TRANSACTIONS
  // ========================================================================

  /// Obtenir les transactions de l'utilisateur
  Future<List<Transaction>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? filter,
    String sort = '-created',
  }) async {
    try {
      if (_currentUser == null) return [];

      final defaultFilter = 'sender = "${_currentUser!.id}" || receiver = "${_currentUser!.id}"';
      final finalFilter = filter != null ? '$defaultFilter && $filter' : defaultFilter;

      final result = await _pb.collection(PocketBaseConfig.collectionTransactions).getList(
        page: page,
        perPage: perPage,
        filter: finalFilter,
        sort: sort,
      );

      return result.items.map((item) => Transaction.fromJson(item.toJson())).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des transactions: $e');
      return [];
    }
  }

  /// Créer une transaction
  Future<Transaction> createTransaction({
    required String receiverId,
    required double amount,
    required String type,
    required String method,
    String? notes,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      if (_currentUser == null) throw Exception('Utilisateur non authentifié');

      final body = {
        'sender': _currentUser!.id,
        'receiver': receiverId,
        'amount': amount,
        'currency': PocketBaseConfig.defaultCurrency,
        'type': type,
        'method': method,
        'status': 'pending',
        'notes': notes,
        'metadata': metadata,
      };

      final record = await _pb.collection(PocketBaseConfig.collectionTransactions).create(body: body);
      return Transaction.fromJson(record.toJson());
    } catch (e) {
      debugPrint('Erreur lors de la création de la transaction: $e');
      rethrow;
    }
  }

  // ========================================================================
  // TONTINES
  // ========================================================================

  /// Obtenir les tontines de l'utilisateur
  Future<List<Tontine>> getTontines() async {
    try {
      if (_currentUser == null) return [];

      final result = await _pb.collection(PocketBaseConfig.collectionTontines).getList(
        filter: 'creator = "${_currentUser!.id}" || @request.auth.id in members',
        sort: '-created',
      );

      return result.items.map((item) => Tontine.fromJson(item.toJson())).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des tontines: $e');
      return [];
    }
  }

  /// Créer une tontine
  Future<Tontine> createTontine({
    required String name,
    String? description,
    required double contributionAmount,
    required String frequency,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (_currentUser == null) throw Exception('Utilisateur non authentifié');

      final body = {
        'name': name,
        'description': description,
        'creator': _currentUser!.id,
        'members': [_currentUser!.id],
        'contribution_amount': contributionAmount,
        'frequency': frequency,
        'type': type,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'status': 'recruiting',
        'total_collected': 0.0,
      };

      final record = await _pb.collection(PocketBaseConfig.collectionTontines).create(body: body);
      return Tontine.fromJson(record.toJson());
    } catch (e) {
      debugPrint('Erreur lors de la création de la tontine: $e');
      rethrow;
    }
  }

  // ========================================================================
  // NOTIFICATIONS
  // ========================================================================

  /// Obtenir les notifications
  Future<List<Notification>> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  }) async {
    try {
      if (_currentUser == null) return [];

      final filter = unreadOnly ? 'user = "${_currentUser!.id}" && is_read = false' : 'user = "${_currentUser!.id}"';

      final result = await _pb.collection(PocketBaseConfig.collectionNotifications).getList(
        page: page,
        perPage: perPage,
        filter: filter,
        sort: '-created',
      );

      return result.items.map((item) => Notification.fromJson(item.toJson())).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des notifications: $e');
      return [];
    }
  }

  /// Marquer une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _pb.collection(PocketBaseConfig.collectionNotifications).update(
        notificationId,
        body: {
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la notification: $e');
    }
  }

  // ========================================================================
  // KYC
  // ========================================================================

  /// Obtenir le statut KYC
  Future<KYC?> getKYCStatus() async {
    try {
      if (_currentUser == null) return null;

      final record = await _pb.collection(PocketBaseConfig.collectionKyc).getFirstListItem(
        'user = "${_currentUser!.id}"',
      );

      return KYC.fromJson(record.toJson());
    } catch (e) {
      debugPrint('Erreur lors de la récupération du statut KYC: $e');
      return null;
    }
  }

  // ========================================================================
  // TICKETS SUPPORT
  // ========================================================================

  /// Obtenir les tickets de support
  Future<List<SupportTicket>> getTickets() async {
    try {
      if (_currentUser == null) return [];

      final result = await _pb.collection(PocketBaseConfig.collectionTickets).getList(
        filter: 'user = "${_currentUser!.id}"',
        sort: '-created',
      );

      return result.items.map((item) => SupportTicket.fromJson(item.toJson())).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des tickets: $e');
      return [];
    }
  }

  /// Créer un ticket de support
  Future<SupportTicket> createTicket({
    required String category,
    required String subject,
    required String description,
    String priority = 'medium',
  }) async {
    try {
      if (_currentUser == null) throw Exception('Utilisateur non authentifié');

      final body = {
        'user': _currentUser!.id,
        'category': category,
        'subject': subject,
        'description': description,
        'status': 'open',
        'priority': priority,
      };

      final record = await _pb.collection(PocketBaseConfig.collectionTickets).create(body: body);
      return SupportTicket.fromJson(record.toJson());
    } catch (e) {
      debugPrint('Erreur lors de la création du ticket: $e');
      rethrow;
    }
  }

  // ========================================================================
  // SERVICES
  // ========================================================================

  /// Obtenir les services de l'écosystème
  Future<List<Service>> getServices() async {
    try {
      final result = await _pb.collection(PocketBaseConfig.collectionServices).getList(
        filter: 'is_active = true',
        sort: 'order',
      );

      return result.items.map((item) => Service.fromJson(item.toJson())).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des services: $e');
      return [];
    }
  }

  // ========================================================================
  // SUBSCRIPTIONS TEMPS RÉEL
  // ========================================================================

  /// S'abonner aux transactions en temps réel
  void subscribeToTransactions(Function(Transaction) onUpdate) {
    try {
      _pb.collection(PocketBaseConfig.collectionTransactions).subscribe('*', (e) {
        if (e.record != null) {
          final transaction = Transaction.fromJson(e.record!.toJson());
          onUpdate(transaction);
        }
      });
    } catch (e) {
      debugPrint('Erreur lors de l\'abonnement aux transactions: $e');
    }
  }

  /// S'abonner aux notifications en temps réel
  void subscribeToNotifications(Function(Notification) onUpdate) {
    try {
      if (_currentUser == null) return;

      _pb.collection(PocketBaseConfig.collectionNotifications).subscribe('*', (e) {
        if (e.record != null) {
          final notification = Notification.fromJson(e.record!.toJson());
          if (notification.userId == _currentUser!.id) {
            onUpdate(notification);
          }
        }
      });
    } catch (e) {
      debugPrint('Erreur lors de l\'abonnement aux notifications: $e');
    }
  }

  /// Arrêter tous les abonnements
  void unsubscribeAll() {
    try {
      _pb.realtime.unsubscribeByPrefix('');
    } catch (e) {
      debugPrint('Erreur lors de l\'arrêt des abonnements: $e');
    }
  }

  @override
  void dispose() {
    unsubscribeAll();
    super.dispose();
  }
}
