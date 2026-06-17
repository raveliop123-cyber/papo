# PAPO - Portefeuille Électronique & Écosystème de Services Financiers

## 📱 Vue d'ensemble

**Papo** est une application mobile Flutter complète et professionnelle pour un portefeuille électronique (e-wallet) avec support des paiements offline, gestion de tontines, et écosystème de services financiers.

### Caractéristiques principales

✅ **Authentification sécurisée** : Phone + PIN + Biométrie  
✅ **Portefeuille multi-devises** : XOF, USD, EUR, GBP  
✅ **Transactions online/offline** : NFC, QR, Bluetooth  
✅ **Système de tontines** : Cercles d'épargne avec distribution  
✅ **Notifications temps réel** : Via PocketBase subscriptions  
✅ **Support client 24/7** : Tickets avec SLA 48h  
✅ **KYC complet** : Vérification d'identité en 3 niveaux  
✅ **Écosystème de services** : Intégration d'autres apps du groupe  
✅ **Panel admin web** : Gestion complète de la plateforme  
✅ **Design magnifique** : Thèmes clair/sombre professionnels  

---

## 🏗️ Architecture

### Structure du projet

```
papo_flutter_complete/
├── lib/
│   ├── config/
│   │   └── pocketbase_config.dart        # Configuration PocketBase
│   ├── models/
│   │   └── models.dart                   # Modèles de données
│   ├── services/
│   │   └── pocketbase_service.dart       # Service PocketBase
│   ├── screens/                          # Écrans de l'application
│   ├── widgets/                          # Composants réutilisables
│   ├── theme/
│   │   └── app_theme.dart                # Thèmes clair/sombre
│   ├── utils/                            # Utilitaires
│   ├── providers/                        # State management
│   └── main.dart                         # Point d'entrée
├── assets/
│   ├── images/                           # Images
│   ├── icons/                            # Icônes
│   ├── animations/                       # Animations Lottie
│   ├── logos/                            # Logos
│   └── fonts/                            # Polices personnalisées
├── test/                                 # Tests unitaires
├── pubspec.yaml                          # Dépendances
└── README.md                             # Cette documentation
```

### Stack technologique

| Composant | Technologie | Version |
|---|---|---|
| **Frontend** | Flutter | 3.22.0+ |
| **Backend** | PocketBase | 0.22.x |
| **State Management** | Provider | 6.1.2+ |
| **UI Framework** | Material Design 3 | - |
| **Authentification** | JWT + Phone Auth | - |
| **Temps Réel** | WebSocket | - |
| **Paiements Offline** | NFC, QR, Bluetooth | - |

---

## 🚀 Installation et Configuration

### Prérequis

- Flutter 3.22.0 ou supérieur
- Dart 3.0.0 ou supérieur
- Android SDK 21+ (pour Android)
- PocketBase 0.22.x auto-hébergé

### Installation

1. **Cloner le dépôt**

```bash
git clone https://github.com/raveliop123-cyber/papo.git
cd papo_flutter_complete
```

2. **Installer les dépendances**

```bash
flutter pub get
```

3. **Configurer PocketBase**

- Télécharger PocketBase depuis [pocketbase.io](https://pocketbase.io)
- Démarrer le serveur : `./pocketbase serve`
- Importer le schéma : Voir section [Schéma PocketBase](#schéma-pocketbase)

4. **Mettre à jour la configuration**

Éditer `lib/config/pocketbase_config.dart` :

```dart
static const String pbUrl = 'http://82.165.150.150:20080'; // URL de votre serveur
```

5. **Lancer l'application**

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web (admin)
flutter run -d chrome
```

---

## 🔐 Schéma PocketBase

### Collections principales

Le schéma PocketBase complet est fourni dans `pocketbase_schema_complete.json`.

#### Collections

| Collection | Description | Type |
|---|---|---|
| **users** | Utilisateurs (auth) | Auth |
| **papo_wallets** | Portefeuilles | Base |
| **papo_transactions** | Transactions | Base |
| **papo_kyc** | Vérification KYC | Base |
| **papo_tontines** | Tontines/Cercles | Base |
| **papo_tontine_contributions** | Contributions | Base |
| **papo_notifications** | Notifications | Base |
| **papo_tickets** | Tickets support | Base |
| **papo_ticket_messages** | Messages support | Base |
| **papo_services** | Services écosystème | Base |
| **papo_devices** | Appareils connectés | Base |
| **papo_activity_logs** | Logs d'activité | Base |
| **papo_merchants** | Marchands | Base |

### Importer le schéma

1. Ouvrir le dashboard PocketBase : `http://localhost:8090/_/`
2. Aller à **Settings > Import collections**
3. Charger le fichier `pocketbase_schema_complete.json`
4. Cliquer sur **Import**

### Authentification

**Méthode** : Phone + PIN  
**URL de base** : `http://82.165.150.150:20080`

```dart
// Exemple d'authentification
final authData = await pb.collection('users').authWithPassword(
  '+221771234567',  // Phone
  '1234',           // PIN
);
```

---

## 📚 Utilisation de l'API PocketBase

### Initialiser le service

```dart
final pbService = PocketBaseService();
await pbService.init();
```

### Authentification

```dart
// Inscription
final user = await pbService.signup(
  phone: '+221771234567',
  pin: '1234',
  name: 'John Doe',
  email: 'john@example.com',
);

// Connexion
final user = await pbService.login('+221771234567', '1234');

// Déconnexion
await pbService.logout();
```

### Portefeuille

```dart
// Obtenir le portefeuille
final wallet = await pbService.getWallet();
print('Solde: ${wallet?.formattedBalance}');
```

### Transactions

```dart
// Récupérer les transactions
final transactions = await pbService.getTransactions(
  page: 1,
  perPage: 20,
  sort: '-created',
);

// Créer une transaction
final transaction = await pbService.createTransaction(
  receiverId: 'user_id_receiver',
  amount: 50000,
  type: 'transfer',
  method: 'online',
  notes: 'Paiement loyer',
);
```

### Tontines

```dart
// Récupérer les tontines
final tontines = await pbService.getTontines();

// Créer une tontine
final tontine = await pbService.createTontine(
  name: 'Tontine Dakar 2024',
  description: 'Épargne collective',
  contributionAmount: 50000,
  frequency: 'monthly',
  type: 'simple',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 365)),
);
```

### Notifications

```dart
// Récupérer les notifications
final notifications = await pbService.getNotifications(
  page: 1,
  perPage: 20,
  unreadOnly: true,
);

// S'abonner aux notifications en temps réel
pbService.subscribeToNotifications((notification) {
  print('Nouvelle notification: ${notification.title}');
});
```

### Tickets support

```dart
// Créer un ticket
final ticket = await pbService.createTicket(
  category: 'transaction',
  subject: 'Transaction échouée',
  description: 'Ma transaction n\'a pas fonctionné...',
  priority: 'high',
);

// Récupérer les tickets
final tickets = await pbService.getTickets();
```

---

## 🎨 Thèmes et Design

### Palettes de couleurs

#### Thème clair

```
Primaire : #2563EB (Bleu)
Secondaire : #10B981 (Vert)
Accent : #F59E0B (Orange)
Danger : #EF4444 (Rouge)
Texte : #1F2937 (Gris foncé)
Fond : #FFFFFF (Blanc)
```

#### Thème sombre

```
Primaire : #3B82F6 (Bleu clair)
Secondaire : #34D399 (Vert lumineux)
Accent : #FBBF24 (Orange clair)
Danger : #F87171 (Rouge clair)
Texte : #F3F4F6 (Blanc cassé)
Fond : #111827 (Noir profond)
```

### Typographie

- **Titres** : Poppins Bold (24-32px)
- **Sous-titres** : Poppins SemiBold (16-20px)
- **Corps** : Inter Regular (14-16px)
- **Petits textes** : Inter Regular (12px)

---

## 🔒 Sécurité

### Authentification

- ✅ JWT avec signature HS256
- ✅ Biométrie (empreinte/visage)
- ✅ PIN 4-6 chiffres
- ✅ Stockage sécurisé des tokens

### Chiffrement

- ✅ AES-256 pour données sensibles
- ✅ SHA-256 pour hashing
- ✅ HTTPS/TLS 1.3 obligatoire

### Conformité

- ✅ RGPD (Europe)
- ✅ Lois locales (Afrique)
- ✅ PCI DSS (si paiements cartes)

---

## 📱 Paiements Offline

### NFC (Near Field Communication)

```dart
// Paiement par NFC
await nfcService.initiateNFCPayment(amount: 50000);
```

**Limite** : 50 000 XOF par transaction  
**Validation** : Biométrique

### QR Code

```dart
// Générer un QR code
final qrData = await qrService.generateQR(
  amount: 50000,
  merchantId: 'merchant_123',
);

// Scanner un QR code
final result = await qrService.scanQR();
```

### Bluetooth

```dart
// Connexion Bluetooth
await bleService.connectToDevice(deviceId);

// Paiement via Bluetooth
await bleService.initiatePayment(amount: 50000);
```

---

## 🧪 Tests

### Tests unitaires

```bash
flutter test
```

### Tests d'intégration

```bash
flutter test integration_test/
```

### Tests de performance

```bash
flutter run --profile
```

---

## 📦 Build et Déploiement

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS

```bash
# Build IPA
flutter build ios --release
```

### Web (Admin)

```bash
# Build web
flutter build web --release
```

---

## 📋 Cahier de Charges

Le cahier de charges complet est disponible dans `CAHIER_DE_CHARGES_PAPO.md`.

Il contient :
- Vue d'ensemble du projet
- Architecture technique
- Spécifications de tous les modules
- Design et UX/UI
- Sécurité et conformité
- Calendrier de développement

---

## 🤝 Contribution

Les contributions sont bienvenues ! Veuillez :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

## 📞 Support

Pour toute question ou problème :

- 📧 Email : support@papo.app
- 🐛 Issues : [GitHub Issues](https://github.com/raveliop123-cyber/papo/issues)
- 💬 Discussions : [GitHub Discussions](https://github.com/raveliop123-cyber/papo/discussions)

---

## 🙏 Remerciements

- [Flutter](https://flutter.dev) - Framework
- [PocketBase](https://pocketbase.io) - Backend
- [Google Fonts](https://fonts.google.com) - Typographie
- [Material Design](https://material.io) - Design System

---

**Développé avec ❤️ par Manus AI**

Version 1.0.0 - Juin 2026
