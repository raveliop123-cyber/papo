/// Configuration PocketBase pour l'application Papo
/// 
/// Ce fichier centralise toutes les configurations de connexion
/// au backend PocketBase auto-hébergé.
/// 
/// URL Backend : http://82.165.150.150:20080
/// Authentification : Phone + PIN
/// Tokens : JWT (2 semaines d'expiration)

class PocketBaseConfig {
  /// URL du serveur PocketBase
  static const String pbUrl = 'http://82.165.150.150:20080';

  /// Collections PocketBase
  static const String collectionUsers = 'users';
  static const String collectionWallets = 'papo_wallets';
  static const String collectionTransactions = 'papo_transactions';
  static const String collectionKyc = 'papo_kyc';
  static const String collectionTontines = 'papo_tontines';
  static const String collectionTontineContributions = 'papo_tontine_contributions';
  static const String collectionNotifications = 'papo_notifications';
  static const String collectionTickets = 'papo_tickets';
  static const String collectionTicketMessages = 'papo_ticket_messages';
  static const String collectionServices = 'papo_services';
  static const String collectionDevices = 'papo_devices';
  static const String collectionActivityLogs = 'papo_activity_logs';
  static const String collectionMerchants = 'papo_merchants';

  /// Limites de transaction
  static const double defaultDailyLimit = 500000;
  static const double defaultMonthlyLimit = 5000000;
  static const double nfcPaymentLimit = 50000;
  static const double offlineTransactionLimit = 100000;

  /// Frais de transaction (en pourcentage)
  static const double transferFee = 0.5;
  static const double depositFee = 1.0;
  static const double withdrawalFee = 1.0;
  static const double paymentFee = 0.25;

  /// Délais (en heures)
  static const int kycVerificationDelay = 48;
  static const int ticketResolutionSLA = 48;
  static const int sessionTimeout = 30; // minutes

  /// Authentification
  static const int minPinLength = 4;
  static const int maxPinLength = 6;
  static const int otpExpirationMinutes = 5;
  static const int maxLoginAttempts = 3;
  static const int loginAttemptLockoutMinutes = 15;

  /// KYC Levels
  static const int kycLevel1 = 1;
  static const int kycLevel2 = 2;
  static const int kycLevel3 = 3;

  /// Tailles de fichiers (en bytes)
  static const int maxAvatarSize = 5242880; // 5MB
  static const int maxDocumentSize = 10485760; // 10MB
  static const int maxSelfieSize = 5242880; // 5MB

  /// Devises supportées
  static const List<String> supportedCurrencies = ['XOF', 'USD', 'EUR', 'GBP'];
  static const String defaultCurrency = 'XOF';

  /// Langues supportées
  static const List<String> supportedLanguages = ['fr', 'en', 'es', 'pt'];
  static const String defaultLanguage = 'fr';

  /// Pays supportés
  static const List<String> supportedCountries = [
    'SN', // Sénégal
    'CI', // Côte d'Ivoire
    'BF', // Burkina Faso
    'ML', // Mali
    'NE', // Niger
    'TG', // Togo
    'BJ', // Bénin
    'GH', // Ghana
    'NG', // Nigeria
    'KE', // Kenya
    'UG', // Ouganda
    'TZ', // Tanzanie
    'ZA', // Afrique du Sud
  ];

  /// Catégories de tontines
  static const List<String> tontineFrequencies = ['daily', 'weekly', 'biweekly', 'monthly'];
  static const List<String> tontineTypes = ['simple', 'hierarchical', 'mixed'];

  /// Catégories de support
  static const List<String> ticketCategories = ['transaction', 'account', 'security', 'technical', 'other'];
  static const List<String> ticketPriorities = ['low', 'medium', 'high', 'critical'];

  /// Catégories de services
  static const List<String> serviceCategories = ['payment', 'investment', 'insurance', 'credit', 'business', 'other'];

  /// Types d'utilisateurs
  static const List<String> userTypes = ['individual', 'merchant', 'admin', 'support'];

  /// Statuts de transaction
  static const List<String> transactionStatuses = ['pending', 'completed', 'failed', 'cancelled', 'reversed'];
  static const List<String> transactionTypes = ['deposit', 'withdrawal', 'transfer', 'payment', 'tontine_contribution', 'tontine_distribution'];
  static const List<String> transactionMethods = ['online', 'nfc', 'qr', 'bluetooth', 'manual'];

  /// Thèmes
  static const List<String> themeOptions = ['light', 'dark', 'system'];

  /// Notifications
  static const List<String> notificationTypes = ['transaction', 'tontine', 'kyc', 'support', 'security', 'ecosystem', 'promotion'];
  static const List<String> notificationPriorities = ['low', 'medium', 'high', 'critical'];
}
