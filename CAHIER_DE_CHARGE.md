# Cahier des Charges - Application PAPO

## 1. Introduction
PAPO est une solution de paiement et de services financiers intégrés visant à offrir une expérience utilisateur fluide, sécurisée et polyvalente. Ce document détaille les spécifications fonctionnelles et techniques pour la refonte de l'interface et l'ajout de nouvelles fonctionnalités majeures.

## 2. Fonctionnalités Principales

### 2.1 Cercle (Tontines)
*   **Création de Cercle :** Possibilité pour un utilisateur de créer une tontine avec des paramètres définis (montant de la cotisation, fréquence, nombre de participants).
*   **Gestion des Membres :** Invitation via numéro de téléphone ou QR code.
*   **Automatique/Manuel :** Prélèvement automatique des cotisations sur le portefeuille PAPO.
*   **Suivi en temps réel :** Calendrier des tours de rôle, historique des paiements et statut des membres.

### 2.2 Paiement Offline & Proximité
*   **Paiement NFC :** Paiement sans contact entre deux appareils compatibles ou via un tag NFC.
*   **Paiement QR Code :** Génération de QR codes dynamiques pour les transactions marchandes ou entre particuliers.
*   **Paiement Bluetooth :** Alternative pour les paiements de proximité sans connexion internet immédiate.
*   **Synchronisation différée :** Les transactions offline sont sécurisées localement et synchronisées dès que la connexion est rétablie.

### 2.3 Gestion des Notifications
*   **Notifications Push :** Alertes de transaction, rappels de tontine, messages de support.
*   **Centre de Notifications :** Historique complet des notifications au sein de l'application.
*   **Paramétrage :** Personnalisation des alertes (son, importance, types de notifications).

### 2.4 Écosystème PAPO
*   **Vitrine des Services :** Présentation des autres services et applications du groupe.
*   **Intégration fluide :** Accès direct ou liens profonds vers les applications partenaires.
*   **Avantages croisés :** Réductions ou bonus pour l'utilisation multi-services.

### 2.5 Module d'Aide & Support
*   **Tickets de Support :** Création de tickets avec une garantie de réponse sous 48h.
*   **Chat en direct :** Discussion instantanée avec des agents de support ou un bot intelligent.
*   **FAQ :** Base de connaissances dynamique pour les questions fréquentes.

## 3. Refonte de l'Interface (UI/UX)

### 3.1 Design Mobile
*   **Expérience Moderne :** Navigation intuitive, animations fluides et composants standardisés.
*   **Cohérence Visuelle :** Utilisation d'une grille stricte et d'une typographie lisible.

### 3.2 Interface Administration
*   **Dashboard Complet :** Vue d'ensemble des transactions, utilisateurs et tickets.
*   **Gestion des Paramètres :** Configuration globale de l'application et de l'écosystème.

### 3.3 Thèmes (Clair et Sombre)
*   **Thème Clair :**
    *   Primaire : #3F51B5 (Bleu Indigo)
    *   Secondaire : #FF4081 (Rose Accent)
    *   Fond : #F5F5F5 (Gris Très Clair)
    *   Surface : #FFFFFF
    *   Texte : #212121
*   **Thème Sombre :**
    *   Primaire : #9FA8DA
    *   Secondaire : #FF80AB
    *   Fond : #121212
    *   Surface : #1E1E1E
    *   Texte : #E0E0E0

## 4. Spécifications Techniques

### 4.1 Backend - PocketBase
Utilisation de PocketBase pour la gestion en temps réel des données, de l'authentification et du stockage des fichiers. Le schéma doit être optimisé pour la robustesse et la rapidité des requêtes `expand`.

### 4.2 Temps Réel
Toutes les collections liées aux transactions, tontines et messages de chat doivent supporter les abonnements en temps réel pour une mise à jour instantanée de l'interface utilisateur.

## 5. Schéma de Données (PocketBase)
*Voir le fichier `pb_schema.json` pour le détail complet des collections et des relations.*
