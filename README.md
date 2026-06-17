# PAPO — Android Flutter + PocketBase + Panel Admin Web

PAPO est une application Flutter Android de paiement, tontines/cerccles, paiement de proximité/offline NFC/QR/Bluetooth, notifications, écosystème de services et support client avec tickets 48h + chat.

## Backend PocketBase

Serveur cible : `http://82.165.150.150:20080/`

La collection d'authentification est nommée `papo_users` afin que le SDK Flutter puisse utiliser :

```dart
final pb = PocketBase('http://82.165.150.150:20080/');
final record = await pb.collection('papo_users').getOne('RECORD_ID');
```

Importez `pb_schema.json` dans PocketBase Admin > Settings > Import collections.

## Design

Le projet utilise une direction artistique africaine premium :

- thème clair **Savane solaire** : terre cuite, or sahel, vert baobab, sable clair ;
- thème sombre **Nuit indigo** : nuit profonde, indigo textile, turquoise, or doux ;
- gradients, cartes arrondies, motifs inspirés bogolan/kente/ndop en texture légère.

## Documentation complète

Le cahier des charges complet, les règles métier, la documentation d'installation et le JSON PocketBase complet sont dans [`CAHIER_DE_CHARGE.md`](CAHIER_DE_CHARGE.md).

## Développement Flutter

```bash
flutter pub get
flutter run
```

## Collections principales

- `papo_users`
- `papo_wallets`
- `papo_transactions`
- `papo_payment_requests`
- `papo_offline_sessions`
- `papo_tontines`
- `papo_tontine_members`
- `papo_tontine_contributions`
- `papo_tontine_payouts`
- `papo_notifications`
- `papo_support_tickets`
- `papo_support_messages`
- `papo_ecosystem`
- `papo_admin_audit_logs`
