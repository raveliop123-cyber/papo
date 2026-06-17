# 📱 PAPO - Solution de Paiement & Tontine Moderne

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![PocketBase](https://img.shields.io/badge/PocketBase-%23000000.svg?style=for-the-badge&logo=pocketbase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

**PAPO** est une application financière tout-en-un conçue pour simplifier les paiements quotidiens et moderniser la pratique traditionnelle de la tontine. Grâce à une interface premium et des fonctionnalités de pointe, PAPO offre une expérience sécurisée, fluide et accessible.

---

## 🚀 Fonctionnalités Clés

### 💳 Paiements Multi-Canaux
- **NFC (Sans contact)** : Payez instantanément en approchant votre téléphone.
- **QR Code** : Scannez ou générez des codes QR pour des transactions rapides.
- **Bluetooth** : Paiements de proximité même sans connexion internet immédiate.

### 👥 Cercles (Tontines)
- Créez ou rejoignez des cercles de confiance.
- Automatisez vos cotisations.
- Suivez l'ordre de réception en temps réel.

### 💬 Support & Assistance
- Système de tickets intégré avec réponse sous 48h.
- Chat en direct avec des agents de support.
- Base de connaissances (FAQ) interactive.

### 🌐 Écosystème
- Découvrez les autres services du groupe PAPO.
- Intégration transparente avec les applications partenaires.

### 🛡️ Sécurité & KYC
- Vérification d'identité robuste (KYC).
- Authentification par code PIN sécurisé.
- Chiffrement des données de bout en bout.

---

## 🎨 Design & UI/UX
L'application propose deux thèmes cohérents et modernes :
- **Thème Clair** : Une interface épurée avec des tons indigo et rose accent.
- **Thème Sombre** : Un design "True Black" optimisé pour les écrans OLED et le confort visuel nocturne.
- **Gradients Premium** : Utilisation de dégradés pour une sensation de profondeur et de modernité.

---

## 🛠️ Stack Technique

- **Frontend** : Flutter (Dart)
- **Backend** : PocketBase (Golang based)
- **State Management** : Provider
- **Real-time** : SSE (Server-Sent Events) via PocketBase SDK
- **CI/CD** : GitHub Actions (Auto-build APK/AAB)

---

## ⚙️ Installation & Configuration

### Prérequis
- Flutter SDK (v3.16+)
- Un serveur PocketBase opérationnel

### Étapes
1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd papo_app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration Backend**
   - Importez le fichier `pb_schema.json` dans votre interface PocketBase (Paramètres > Import Collections).
   - Mettez à jour l'URL du serveur dans `lib/services/pocketbase_service.dart`.

4. **Lancer l'application**
   ```bash
   flutter run
   ```

---

## 📦 Builds & Livraison
Le projet utilise GitHub Actions pour générer automatiquement les fichiers de release :
- **APK** : Pour une installation directe sur Android.
- **AAB** : Pour la publication sur le Google Play Store.

Les fichiers sont disponibles dans l'onglet **Actions** de votre dépôt GitHub après chaque push.

---

## 📄 Licence
© 2024 Groupe PAPO. Tous droits réservés.
