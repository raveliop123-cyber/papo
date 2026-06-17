# CAHIER DE CHARGES COMPLET - PAPO
## Application de Portefeuille Électronique & Écosystème de Services Financiers

**Version** : 1.0  
**Date** : Juin 2026  
**Statut** : Spécification Technique Complète  
**Plateforme** : Android (Flutter) + Admin Web  
**Backend** : PocketBase Auto-hébergé (http://82.165.150.150:20080)

---

## TABLE DES MATIÈRES

1. [Vue d'ensemble du projet](#1-vue-densemble-du-projet)
2. [Architecture générale](#2-architecture-générale)
3. [Spécifications techniques](#3-spécifications-techniques)
4. [Modules fonctionnels](#4-modules-fonctionnels)
5. [Design et UX/UI](#5-design-et-uxui)
6. [Sécurité et conformité](#6-sécurité-et-conformité)
7. [Schéma PocketBase](#7-schéma-pocketbase)
8. [Calendrier de développement](#8-calendrier-de-développement)

---

## 1. VUE D'ENSEMBLE DU PROJET

### 1.1 Objectif Principal

**Papo** est une plateforme de portefeuille électronique (e-wallet) complète destinée aux utilisateurs africains, offrant :
- Gestion de portefeuille multi-devises
- Transactions en ligne et hors ligne (NFC, QR, Bluetooth)
- Système de tontines (cercles d'épargne)
- Écosystème de services du groupe
- Support client 24/7 via tickets
- Espace administrateur pour la gestion globale

### 1.2 Cibles Utilisateurs

| Type d'utilisateur | Description | Fonctionnalités clés |
|---|---|---|
| **Utilisateur Standard** | Individus utilisant le portefeuille | Transactions, tontines, paiements, notifications |
| **Marchand** | Commerçants acceptant les paiements Papo | Acceptation de paiements, rapports, QR dynamiques |
| **Administrateur** | Gestionnaires de la plateforme | Gestion complète, modération, statistiques |
| **Support** | Équipe d'assistance client | Gestion des tickets, réponses aux utilisateurs |

### 1.3 Périmètre Fonctionnel

#### Modules Principaux
1. **Authentification & Sécurité**
2. **Gestion du Portefeuille**
3. **Transactions (Online & Offline)**
4. **Système de Tontines**
5. **Notifications en Temps Réel**
6. **KYC (Know Your Customer)**
7. **Module Support (Tickets 48h)**
8. **Écosystème de Services**
9. **Panel Administrateur Web**
10. **Intégration NFC/QR/Bluetooth**

---

## 2. ARCHITECTURE GÉNÉRALE

### 2.1 Architecture Technique

```
┌─────────────────────────────────────────────────────────────┐
│                    COUCHE PRÉSENTATION                      │
├─────────────────────────────────────────────────────────────┤
│  Application Mobile Flutter (Android)  │  Panel Admin Web   │
│  - Authentification                    │  - Dashboard       │
│  - Portefeuille                        │  - Gestion Users   │
│  - Transactions                        │  - Modération      │
│  - Tontines                            │  - Statistiques    │
│  - Support                             │  - Paramètres      │
│  - Écosystème                          │                    │
├─────────────────────────────────────────────────────────────┤
│                    COUCHE MÉTIER                            │
├─────────────────────────────────────────────────────────────┤
│  Services Flutter                      │  Services Web      │
│  - PocketBase Service                  │  - API Service     │
│  - Auth Service                        │  - Admin Service   │
│  - Wallet Service                      │  - Analytics       │
│  - Transaction Service                 │                    │
│  - Notification Service                │                    │
│  - NFC/QR/BLE Service                  │                    │
├─────────────────────────────────────────────────────────────┤
│                    COUCHE DONNÉES                           │
├─────────────────────────────────────────────────────────────┤
│              PocketBase (Backend)                           │
│  - Collections (Users, Wallets, Transactions, etc.)        │
│  - Authentification (Phone + PIN)                          │
│  - Fichiers (Documents KYC, Avatars)                       │
│  - Subscriptions Temps Réel                                │
│  - Règles d'accès (RLS)                                    │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Stack Technologique

| Composant | Technologie | Version |
|---|---|---|
| **Frontend Mobile** | Flutter | 3.22.0+ |
| **Frontend Admin** | React/Vue.js | 18.x / 3.x |
| **Backend** | PocketBase | 0.22.x |
| **Base de Données** | SQLite/PostgreSQL | - |
| **Authentification** | JWT + Phone Auth | - |
| **Temps Réel** | WebSocket (PocketBase) | - |
| **Paiements Offline** | NFC, QR, Bluetooth | - |
| **State Management** | Provider/Riverpod | 6.x+ |

---

## 3. SPÉCIFICATIONS TECHNIQUES

### 3.1 Environnement de Développement

```yaml
# pubspec.yaml - Dépendances Flutter principales
dependencies:
  flutter:
    sdk: flutter
  
  # Backend & API
  pocketbase: ^0.18.0
  dio: ^5.4.0
  
  # State Management
  provider: ^6.1.2
  riverpod: ^2.4.0
  
  # UI & Design
  google_fonts: ^6.2.1
  flutter_animate: ^4.2.0
  lottie: ^2.7.0
  
  # Authentification & Sécurité
  local_auth: ^2.2.0
  flutter_secure_storage: ^9.0.0
  
  # Paiements Offline
  nfc_manager: ^3.3.0
  mobile_scanner: ^4.0.0
  flutter_blue_plus: ^1.31.0
  
  # Notifications
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^17.0.0
  
  # Utilitaires
  intl: ^0.19.0
  qr_flutter: ^4.1.0
  url_launcher: ^6.3.1
  shared_preferences: ^2.2.0
  connectivity_plus: ^5.0.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### 3.2 Configuration PocketBase

**URL Backend** : `http://82.165.150.150:20080`

**Authentification** :
- Méthode : Phone + PIN
- Token JWT : Durée 2 semaines
- Refresh Token : Automatique
- Biométrie : Optionnelle (empreinte, reconnaissance faciale)

**Règles d'Accès (RLS)** :
- Propriétaire uniquement : `user = @request.auth.id`
- Authentifié uniquement : `@request.auth.id != ""`
- Public : `null` (avec modération)

---

## 4. MODULES FONCTIONNELS

### 4.1 MODULE AUTHENTIFICATION & SÉCURITÉ

#### 4.1.1 Inscription (Sign Up)

**Flux** :
1. Entrée du numéro de téléphone (validation E.164)
2. Vérification OTP (SMS ou appel)
3. Création du PIN (4-6 chiffres)
4. Données personnelles (nom, prénom, email)
5. Acceptation des conditions d'utilisation
6. Création du compte utilisateur

**Données collectées** :
- Numéro de téléphone (unique, vérifié)
- PIN (hashé, salé)
- Nom complet
- Email
- Date de naissance
- Photo de profil (optionnelle)

**Sécurité** :
- Validation du numéro E.164
- PIN hashé avec bcrypt
- OTP expirant après 5 minutes
- Limite de tentatives : 3 par 15 minutes

#### 4.1.2 Connexion (Sign In)

**Flux** :
1. Entrée du numéro de téléphone
2. Entrée du PIN
3. Option : Authentification biométrique (empreinte/visage)
4. Génération du JWT token

**Options de Sécurité** :
- PIN seul
- Biométrie + PIN
- Biométrie seule (après première connexion)

#### 4.1.3 Authentification Biométrique

**Fonctionnalités** :
- Empreinte digitale (Android)
- Reconnaissance faciale (Android 8+)
- Fallback PIN si biométrie échoue
- Activation/Désactivation dans les paramètres

**Implémentation** :
```dart
// Utilisation de local_auth
final LocalAuthentication auth = LocalAuthentication();
final bool canCheckBiometrics = await auth.canCheckBiometrics;
final bool isDeviceSupported = await auth.isDeviceSupported();

final bool didAuthenticate = await auth.authenticate(
  localizedReason: 'Authentifiez-vous pour accéder à Papo',
  options: const AuthenticationOptions(
    stickyAuth: true,
    biometricOnly: true,
  ),
);
```

#### 4.1.4 Gestion des Sessions

**Token Management** :
- Stockage sécurisé : `flutter_secure_storage`
- Refresh automatique avant expiration
- Déconnexion automatique après 30 minutes d'inactivité
- Logout sur tous les appareils

**Persistance** :
```dart
// Stockage sécurisé du token
final secureStorage = FlutterSecureStorage();
await secureStorage.write(
  key: 'auth_token',
  value: token,
  aOptions: _getAndroidOptions(),
  iOptions: _getIOSOptions(),
);
```

---

### 4.2 MODULE PORTEFEUILLE & TRANSACTIONS

#### 4.2.1 Gestion du Portefeuille

**Fonctionnalités** :
- Solde multi-devises (XOF, USD, EUR, etc.)
- Historique des transactions (30 derniers jours)
- Statistiques mensuelles (dépenses, revenus)
- Graphiques d'évolution du solde
- Limite de transaction (configurable par type)

**Données Wallet** :
```json
{
  "id": "wallet_id",
  "user": "user_id",
  "balance": 150000.50,
  "currency": "XOF",
  "daily_limit": 500000,
  "monthly_limit": 5000000,
  "is_active": true,
  "created": "2024-01-01T00:00:00Z",
  "updated": "2024-06-17T15:30:00Z"
}
```

#### 4.2.2 Types de Transactions

| Type | Description | Limite | Frais |
|---|---|---|---|
| **Transfer** | Virement entre utilisateurs Papo | 1M XOF/jour | 0.5% |
| **Deposit** | Dépôt d'argent (via marchand) | Illimité | 1% |
| **Withdrawal** | Retrait d'argent | 500k XOF/jour | 1% |
| **Payment** | Paiement chez marchand | 100k XOF/transaction | 0.25% |
| **Tontine_Contribution** | Contribution tontine | Selon tontine | 0% |

#### 4.2.3 Transactions Hors Ligne

**NFC (Near Field Communication)** :
- Paiement par rapprochement de téléphones
- Validation biométrique
- Synchronisation automatique à la connexion
- Limite : 50k XOF par transaction

**QR Code** :
- Génération de QR dynamiques
- Scan pour paiement/réception
- Intégration avec caméra
- Historique des QR générés

**Bluetooth** :
- Appairage avec terminaux de paiement
- Transmission sécurisée (AES-256)
- Portée : jusqu'à 100 mètres
- Reconnexion automatique

**Implémentation NFC** :
```dart
// Utilisation de nfc_manager
import 'package:nfc_manager/nfc_manager.dart';

Future<void> initiateNFCPayment(double amount) async {
  NfcData? result = await NfcManager.instance.transceive(
    Uint8List.fromList([0x00, 0xA4, 0x04, 0x00, 0x07, ...]),
  );
  
  // Traitement du paiement
  await processOfflineTransaction(
    type: 'nfc_payment',
    amount: amount,
    data: result,
  );
}
```

#### 4.2.4 Historique & Rapports

**Historique Transactions** :
- Filtrage par date, type, montant
- Recherche par destinataire/expéditeur
- Export en PDF/CSV
- Détails complets de chaque transaction

**Rapports Mensuels** :
- Dépenses par catégorie
- Revenus totaux
- Statistiques de paiement
- Graphiques d'évolution

---

### 4.3 MODULE TONTINES (CERCLES D'ÉPARGNE)

#### 4.3.1 Gestion des Tontines

**Fonctionnalités** :
- Création de cercles d'épargne
- Gestion des membres
- Contributions régulières
- Distribution des fonds
- Historique des tours

**Types de Tontines** :
1. **Tontine Simple** : Distribution équitable
2. **Tontine Hiérarchique** : Ordre de priorité
3. **Tontine Mixte** : Combinaison des deux

#### 4.3.2 Cycle de Tontine

**Phases** :
1. **Création** : Initiateur crée le cercle
2. **Recrutement** : Invitation des membres (max 20)
3. **Contribution** : Collecte des contributions mensuelles
4. **Distribution** : Attribution des fonds selon règles
5. **Clôture** : Fin du cycle

**Données Tontine** :
```json
{
  "id": "tontine_id",
  "name": "Tontine Dakar 2024",
  "creator": "user_id",
  "members": ["user_id_1", "user_id_2", ...],
  "contribution_amount": 50000,
  "frequency": "monthly",
  "start_date": "2024-01-01",
  "end_date": "2024-12-31",
  "status": "active",
  "total_collected": 600000,
  "distribution_order": ["user_id_1", "user_id_2", ...],
  "created": "2024-01-01T00:00:00Z"
}
```

#### 4.3.3 Notifications Tontine

- Rappel contribution (3 jours avant)
- Confirmation contribution
- Notification distribution
- Alerte retard de contribution

---

### 4.4 MODULE NOTIFICATIONS EN TEMPS RÉEL

#### 4.4.1 Types de Notifications

| Type | Déclencheur | Canal | Priorité |
|---|---|---|---|
| **Transaction** | Envoi/Réception d'argent | Push + In-app | Haute |
| **Tontine** | Contribution, distribution | Push + In-app | Moyenne |
| **KYC** | Changement de statut | Push + Email | Haute |
| **Support** | Réponse ticket | Push + In-app | Moyenne |
| **Sécurité** | Tentative échouée, changement PIN | Push + Email | Critique |
| **Écosystème** | Nouveaux services | In-app | Basse |

#### 4.4.2 Implémentation Temps Réel

**Utilisation de PocketBase Subscriptions** :
```dart
// Abonnement aux transactions en temps réel
pb.collection('papo_transactions').subscribe('*', (e) {
  if (e.record != null) {
    final transaction = Transaction.fromRecord(e.record!.toJson());
    
    // Mise à jour UI
    notificationService.showNotification(
      title: 'Nouvelle transaction',
      body: 'Vous avez reçu ${transaction.amount} ${transaction.currency}',
      data: {'transaction_id': transaction.id},
    );
  }
});
```

#### 4.4.3 Préférences de Notification

- Activation/Désactivation par type
- Horaires de silence (ex: 22h-8h)
- Son et vibration
- Affichage sur l'écran de verrouillage

---

### 4.5 MODULE KYC (KNOW YOUR CUSTOMER)

#### 4.5.1 Processus KYC

**Niveaux de Vérification** :

| Niveau | Documents | Limite Transaction | Délai |
|---|---|---|---|
| **Level 1** | Numéro téléphone | 100k XOF/jour | Immédiat |
| **Level 2** | ID + Selfie | 1M XOF/jour | 24-48h |
| **Level 3** | ID + Adresse + Selfie | Illimité | 48-72h |

#### 4.5.2 Documents Acceptés

**Identité** :
- Carte d'identité nationale
- Passeport
- Permis de conduire

**Adresse** :
- Facture d'électricité/eau
- Contrat de location
- Relevé bancaire

**Selfie** :
- Photo du visage (éclairage naturel)
- Pas de filtre ou maquillage excessif

#### 4.5.3 Flux KYC

```
1. Sélection du type de document
2. Capture/Upload du document
3. Capture du selfie
4. Vérification automatique (OCR)
5. Vérification manuelle (48h)
6. Approbation/Rejet
7. Notification utilisateur
```

**Données KYC** :
```json
{
  "id": "kyc_id",
  "user": "user_id",
  "level": 2,
  "document_type": "id_card",
  "document_number": "ABC123456",
  "document_file": "kyc_documents/...",
  "selfie_file": "kyc_selfies/...",
  "status": "approved",
  "verified_at": "2024-06-17T10:30:00Z",
  "created": "2024-06-15T08:00:00Z"
}
```

---

### 4.6 MODULE SUPPORT CLIENT (TICKETS 48H)

#### 4.6.1 Système de Tickets

**Fonctionnalités** :
- Création de tickets avec catégories
- Chat en temps réel avec support
- Historique des conversations
- Résolution garantie en 48h
- Notation de la résolution

#### 4.6.2 Catégories de Support

| Catégorie | Description | SLA |
|---|---|---|
| **Transaction** | Problème de transaction | 4h |
| **Compte** | Problème de compte/accès | 2h |
| **Sécurité** | Problème de sécurité | 1h |
| **Technique** | Bug ou dysfonctionnement | 6h |
| **Autre** | Autres questions | 24h |

#### 4.6.3 Flux Ticket

```
1. Utilisateur crée un ticket
2. Catégorisation automatique (IA)
3. Attribution à un agent
4. Chat en temps réel
5. Résolution et clôture
6. Notation par utilisateur
7. Archivage
```

**Données Ticket** :
```json
{
  "id": "ticket_id",
  "user": "user_id",
  "category": "transaction",
  "subject": "Transaction échouée",
  "description": "...",
  "status": "open",
  "priority": "high",
  "assigned_to": "support_agent_id",
  "messages": [
    {
      "sender": "user_id",
      "content": "...",
      "timestamp": "2024-06-17T10:00:00Z"
    }
  ],
  "created": "2024-06-17T10:00:00Z",
  "resolved_at": null,
  "rating": null
}
```

---

### 4.7 MODULE ÉCOSYSTÈME DE SERVICES

#### 4.7.1 Services du Groupe

**Présentation des Services** :
- Affichage des autres applications du groupe
- Liens directs de téléchargement
- Descriptions et fonctionnalités
- Évaluations et avis utilisateurs

**Services Intégrés** :
1. **Papo Pay** : Paiements en ligne
2. **Papo Invest** : Placements financiers
3. **Papo Insurance** : Assurances
4. **Papo Loans** : Microcrédits
5. **Papo Business** : Solutions B2B

#### 4.7.2 Intégration Cross-App

- Single Sign-On (SSO) entre apps
- Transfert de données sécurisé
- Notifications unifiées
- Portefeuille partagé (optionnel)

**Données Écosystème** :
```json
{
  "id": "service_id",
  "name": "Papo Pay",
  "description": "...",
  "icon": "services/papo_pay_icon.png",
  "download_url": "https://play.google.com/store/apps/details?id=...",
  "rating": 4.8,
  "reviews_count": 1250,
  "category": "payment",
  "is_active": true
}
```

---

### 4.8 MODULE ADMINISTRATEUR WEB

#### 4.8.1 Dashboard Administrateur

**Sections** :
1. **Vue d'ensemble** : KPIs, statistiques globales
2. **Gestion des utilisateurs** : CRUD, suspension, KYC
3. **Gestion des transactions** : Monitoring, fraude
4. **Modération** : Tickets, signalements
5. **Rapports** : Financiers, opérationnels
6. **Paramètres** : Configuration système

#### 4.8.2 Fonctionnalités Admin

| Fonction | Description | Permissions |
|---|---|---|
| **User Management** | Créer, modifier, supprimer utilisateurs | Admin |
| **KYC Review** | Approuver/Rejeter KYC | Modérateur |
| **Transaction Monitoring** | Surveiller transactions suspectes | Admin |
| **Ticket Management** | Assigner, résoudre tickets | Support |
| **Reports** | Générer rapports | Admin |
| **Settings** | Configurer limites, frais | Admin |

#### 4.8.3 Sécurité Admin

- Authentification multi-facteur
- Logs d'audit complets
- Permissions granulaires
- IP whitelist
- Session timeout : 30 minutes

---

## 5. DESIGN ET UX/UI

### 5.1 Palette de Couleurs

#### 5.1.1 Thème Clair

```
Primaire : #2563EB (Bleu professionnel)
Secondaire : #10B981 (Vert succès)
Accent : #F59E0B (Orange notification)
Danger : #EF4444 (Rouge erreur)
Neutre : #F3F4F6 (Gris clair)
Texte : #1F2937 (Gris foncé)
```

**Utilisation** :
- Boutons primaires : Bleu
- Confirmations/Succès : Vert
- Avertissements : Orange
- Erreurs : Rouge
- Fonds : Blanc/Gris clair

#### 5.1.2 Thème Sombre

```
Primaire : #3B82F6 (Bleu clair)
Secondaire : #34D399 (Vert lumineux)
Accent : #FBBF24 (Orange clair)
Danger : #F87171 (Rouge clair)
Neutre : #1F2937 (Gris foncé)
Texte : #F3F4F6 (Blanc cassé)
Fonds : #111827 (Noir profond)
```

### 5.2 Typographie

```
Titres (H1-H3) : Google Fonts - Poppins Bold (24-32px)
Sous-titres : Google Fonts - Poppins SemiBold (16-20px)
Corps : Google Fonts - Inter Regular (14-16px)
Petits textes : Google Fonts - Inter Regular (12px)
Monospace : Google Fonts - JetBrains Mono (12-14px)
```

### 5.3 Composants UI

#### 5.3.1 Cartes (Cards)

```dart
// Carte de transaction
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Icon(Icons.send, color: Colors.blue),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Virement à Ali', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('-50 000 XOF', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        Text('17 Jun', style: TextStyle(color: Colors.grey)),
      ],
    ),
  ),
)
```

#### 5.3.2 Boutons

```dart
// Bouton primaire
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: Text('Envoyer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
)

// Bouton secondaire
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.blue),
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: Text('Annuler'),
)
```

#### 5.3.3 Champs de Saisie

```dart
// Champ texte avec validation
TextField(
  decoration: InputDecoration(
    hintText: 'Numéro de téléphone',
    prefixIcon: Icon(Icons.phone),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.grey[100],
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  keyboardType: TextInputType.phone,
)
```

### 5.4 Animations

- **Transitions** : 300ms (Material Design)
- **Lottie** : Animations pour chargement, succès, erreur
- **Micro-interactions** : Feedback tactile sur boutons
- **Scroll** : Parallax sur header

### 5.5 Responsive Design

| Breakpoint | Largeur | Utilisation |
|---|---|---|
| **Mobile** | < 600px | Téléphones |
| **Tablet** | 600-1200px | Tablettes |
| **Desktop** | > 1200px | Web admin |

---

## 6. SÉCURITÉ ET CONFORMITÉ

### 6.1 Normes de Sécurité

**Chiffrement** :
- AES-256 pour données sensibles
- SHA-256 pour hashing
- RSA-2048 pour clés publiques

**Authentification** :
- JWT avec signature HS256
- Biométrie (empreinte/visage)
- PIN 4-6 chiffres

**Conformité** :
- RGPD (Europe)
- Lois locales (Afrique)
- PCI DSS (si paiements cartes)

### 6.2 Protection des Données

**Stockage** :
- Données sensibles : Base de données chiffrée
- Tokens : Stockage sécurisé (Keychain/Keystore)
- Fichiers : Chiffrement au repos

**Transmission** :
- HTTPS/TLS 1.3 obligatoire
- Certificats SSL valides
- HSTS activé

### 6.3 Audit et Logs

**Événements Loggés** :
- Connexions/Déconnexions
- Transactions (montant, destinataire, statut)
- Modifications de compte
- Tentatives échouées
- Accès admin

**Rétention** : 2 ans minimum

### 6.4 Gestion des Risques

**Fraude** :
- Détection d'anomalies (ML)
- Limite de transactions
- Vérification 3D Secure
- Blacklist de comptes

**DDoS** :
- Rate limiting
- WAF (Web Application Firewall)
- CDN pour distribution

---

## 7. SCHÉMA POCKETBASE

### 7.1 Collections Principales

Voir section [Fichier JSON PocketBase Complet](#fichier-json-pocketbase-complet) ci-dessous.

### 7.2 Relations Entre Collections

```
users (auth)
├── wallets (1:1)
├── transactions (1:N) [sender/receiver]
├── tontines (1:N) [creator/members]
├── kyc (1:1)
├── tickets (1:N)
├── notifications (1:N)
├── devices (1:N)
└── activity_logs (1:N)

tontines
├── members (N:N via tontine_members)
├── contributions (1:N)
└── distributions (1:N)

tickets
├── messages (1:N)
└── attachments (1:N)

services
└── ratings (1:N)
```

### 7.3 Règles d'Accès (RLS)

| Collection | List | View | Create | Update | Delete |
|---|---|---|---|---|---|
| **users** | `id = @request.auth.id` | `id = @request.auth.id` | `` | `id = @request.auth.id` | `id = @request.auth.id` |
| **wallets** | `user = @request.auth.id` | `user = @request.auth.id` | `user = @request.auth.id` | `user = @request.auth.id` | `` |
| **transactions** | `sender = @request.auth.id \|\| receiver = @request.auth.id` | `sender = @request.auth.id \|\| receiver = @request.auth.id` | `sender = @request.auth.id` | `` | `` |
| **kyc** | `user = @request.auth.id` | `user = @request.auth.id` | `user = @request.auth.id` | `` | `` |
| **tickets** | `user = @request.auth.id \|\| @request.auth.role = "support"` | `user = @request.auth.id \|\| @request.auth.role = "support"` | `user = @request.auth.id` | `user = @request.auth.id \|\| @request.auth.role = "support"` | `` |

---

## 8. CALENDRIER DE DÉVELOPPEMENT

### Phase 1 : Fondations (Semaines 1-2)

- [x] Schéma PocketBase complet
- [x] Setup Flutter project
- [x] Architecture et structure
- [ ] Services de base (Auth, Wallet)

### Phase 2 : Authentification (Semaines 3-4)

- [ ] Inscription et connexion
- [ ] Biométrie
- [ ] Gestion des sessions
- [ ] Tests de sécurité

### Phase 3 : Portefeuille (Semaines 5-6)

- [ ] Dashboard
- [ ] Transactions online
- [ ] Historique
- [ ] Rapports

### Phase 4 : Paiements Offline (Semaines 7-8)

- [ ] Intégration NFC
- [ ] Intégration QR
- [ ] Intégration Bluetooth
- [ ] Tests

### Phase 5 : Tontines (Semaines 9-10)

- [ ] Création de cercles
- [ ] Gestion des membres
- [ ] Contributions
- [ ] Distribution

### Phase 6 : Support & Notifications (Semaines 11-12)

- [ ] Système de tickets
- [ ] Chat temps réel
- [ ] Notifications push
- [ ] Subscriptions PocketBase

### Phase 7 : KYC & Écosystème (Semaines 13-14)

- [ ] Processus KYC
- [ ] Vérification documents
- [ ] Module écosystème
- [ ] Intégrations

### Phase 8 : Admin Web (Semaines 15-16)

- [ ] Dashboard admin
- [ ] Gestion utilisateurs
- [ ] Modération
- [ ] Rapports

### Phase 9 : Polish & Tests (Semaines 17-18)

- [ ] Tests unitaires
- [ ] Tests d'intégration
- [ ] Tests de performance
- [ ] Tests de sécurité

### Phase 10 : Déploiement (Semaines 19-20)

- [ ] Build APK/AAB
- [ ] Déploiement Play Store
- [ ] Déploiement admin web
- [ ] Documentation

---

## FICHIER JSON POCKETBASE COMPLET

*Voir fichier séparé : `pocketbase_schema_complete.json`*

---

## CONCLUSION

Ce cahier de charges définit une application complète, sécurisée et scalable. Le développement doit suivre les phases définies, avec tests continus et validation des exigences.

**Prochaines étapes** :
1. Approbation du cahier de charges
2. Création du schéma PocketBase
3. Setup de l'environnement Flutter
4. Développement itératif par phase
5. Tests et déploiement

---

**Document préparé par** : Manus AI  
**Date** : 17 Juin 2026  
**Version** : 1.0 - Complète
