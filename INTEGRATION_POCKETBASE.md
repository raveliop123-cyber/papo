# Guide d'Intégration PocketBase pour Papo

## 📋 Table des matières

1. [Installation de PocketBase](#installation-de-pocketbase)
2. [Configuration initiale](#configuration-initiale)
3. [Importation du schéma](#importation-du-schéma)
4. [Vérification des collections](#vérification-des-collections)
5. [Tests de connexion](#tests-de-connexion)
6. [Dépannage](#dépannage)

---

## Installation de PocketBase

### Étape 1 : Télécharger PocketBase

Accédez à [https://pocketbase.io/](https://pocketbase.io/) et téléchargez la version appropriée pour votre système :

- **Linux** : `pocketbase_0.22.x_linux_amd64.zip`
- **macOS** : `pocketbase_0.22.x_darwin_arm64.zip` ou `pocketbase_0.22.x_darwin_amd64.zip`
- **Windows** : `pocketbase_0.22.x_windows_amd64.zip`

### Étape 2 : Extraire l'archive

```bash
unzip pocketbase_0.22.x_linux_amd64.zip
cd pocketbase
chmod +x pocketbase
```

### Étape 3 : Démarrer le serveur

```bash
./pocketbase serve
```

Par défaut, PocketBase démarre sur :
- **Dashboard** : http://127.0.0.1:8090/_/
- **API** : http://127.0.0.1:8090

---

## Configuration initiale

### Étape 1 : Accéder au dashboard

Ouvrez votre navigateur et allez à : `http://127.0.0.1:8090/_/`

### Étape 2 : Créer un compte admin

Vous verrez un écran pour créer le compte administrateur :

```
Email : admin@papo.local
Mot de passe : VotreMotDePasseSecurisé
```

Cliquez sur **Create admin account**.

### Étape 3 : Se connecter

Utilisez les identifiants créés pour vous connecter au dashboard.

---

## Importation du schéma

### Étape 1 : Accéder aux paramètres

Dans le dashboard PocketBase :
1. Cliquez sur **Settings** (en bas à gauche)
2. Allez à l'onglet **Import collections**

### Étape 2 : Charger le fichier JSON

1. Cliquez sur **Choose file**
2. Sélectionnez le fichier `pocketbase_schema_complete.json`
3. Cliquez sur **Load**

### Étape 3 : Importer les collections

1. Vérifiez que toutes les collections sont listées
2. Cliquez sur **Import**
3. Attendez la confirmation

### Résultat attendu

```
✓ Importation réussie
Collections importées : 13
- users (auth)
- papo_wallets
- papo_transactions
- papo_kyc
- papo_tontines
- papo_tontine_contributions
- papo_notifications
- papo_tickets
- papo_ticket_messages
- papo_services
- papo_devices
- papo_activity_logs
- papo_merchants
```

---

## Vérification des collections

### Vérifier les collections

1. Allez à l'onglet **Collections** dans le dashboard
2. Vous devriez voir les 13 collections listées

### Vérifier les champs de chaque collection

Pour chaque collection, cliquez dessus et vérifiez :

#### Collection `users` (Auth)

Champs attendus :
- `name` (text, requis)
- `avatar` (file)
- `phone` (text, unique, requis)
- `pin` (text, requis)
- `email` (text, unique)
- `date_of_birth` (date)
- `is_verified` (bool)
- `kyc_level` (number)
- `user_type` (select)
- `is_active` (bool)
- `biometric_enabled` (bool)
- `theme_preference` (select)
- `language` (select)
- `country` (text)
- `city` (text)
- `notification_settings` (json)
- `last_login` (date)
- `account_status` (select)

**Authentification** :
- ✓ Phone auth activé
- ✓ Email auth désactivé
- ✓ Min password length : 4

#### Collection `papo_wallets`

Champs attendus :
- `user` (relation → users, unique, requis)
- `balance` (number, requis)
- `currency` (text, requis)
- `daily_limit` (number)
- `monthly_limit` (number)
- `is_active` (bool)
- `total_spent_today` (number)
- `total_spent_month` (number)

**Règles d'accès** :
- List : `user = @request.auth.id`
- View : `user = @request.auth.id`
- Create : `user = @request.auth.id`
- Update : `user = @request.auth.id`

#### Collection `papo_transactions`

Champs attendus :
- `sender` (relation → users, requis)
- `receiver` (relation → users, requis)
- `amount` (number, requis)
- `currency` (text, requis)
- `type` (select, requis)
- `status` (select, requis)
- `method` (select, requis)
- `notes` (text)
- `reference` (text, unique)
- `fee` (number)
- `offline_sync` (bool)
- `metadata` (json)

**Règles d'accès** :
- List : `sender = @request.auth.id || receiver = @request.auth.id`
- View : `sender = @request.auth.id || receiver = @request.auth.id`
- Create : `sender = @request.auth.id`
- Update : (vide)
- Delete : (vide)

---

## Tests de connexion

### Test 1 : Créer un utilisateur

1. Allez à la collection `users`
2. Cliquez sur **New record**
3. Remplissez les champs :
   - `name` : Test User
   - `phone` : +221771234567
   - `pin` : 1234
   - `user_type` : individual
   - `is_active` : true
4. Cliquez sur **Save**

### Test 2 : Se connecter via l'API

Utilisez cURL ou Postman :

```bash
curl -X POST http://127.0.0.1:8090/api/collections/users/auth-with-password \
  -H "Content-Type: application/json" \
  -d '{
    "identity": "+221771234567",
    "password": "1234"
  }'
```

Réponse attendue :

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "record": {
    "id": "user_id",
    "name": "Test User",
    "phone": "+221771234567",
    "user_type": "individual",
    ...
  }
}
```

### Test 3 : Créer un portefeuille

```bash
curl -X POST http://127.0.0.1:8090/api/collections/papo_wallets/records \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user": "user_id",
    "balance": 100000,
    "currency": "XOF",
    "daily_limit": 500000,
    "monthly_limit": 5000000,
    "is_active": true
  }'
```

---

## Configuration pour la production

### Déploiement sur serveur distant

Pour déployer PocketBase sur `http://82.165.150.150:20080` :

1. **Accéder au serveur**

```bash
ssh user@82.165.150.150
```

2. **Installer PocketBase**

```bash
cd /opt/pocketbase
wget https://github.com/pocketbase/pocketbase/releases/download/v0.22.x/pocketbase_0.22.x_linux_amd64.zip
unzip pocketbase_0.22.x_linux_amd64.zip
chmod +x pocketbase
```

3. **Configurer le service systemd**

Créer `/etc/systemd/system/pocketbase.service` :

```ini
[Unit]
Description=PocketBase Service
After=network.target

[Service]
Type=simple
User=pocketbase
WorkingDirectory=/opt/pocketbase
ExecStart=/opt/pocketbase/pocketbase serve --http=0.0.0.0:20080
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

4. **Démarrer le service**

```bash
sudo systemctl daemon-reload
sudo systemctl enable pocketbase
sudo systemctl start pocketbase
```

5. **Vérifier le statut**

```bash
sudo systemctl status pocketbase
```

### Configuration SSL/TLS

Pour utiliser HTTPS, installez un certificat SSL :

```bash
# Avec Let's Encrypt
sudo certbot certonly --standalone -d 82.165.150.150
```

Puis configurez un reverse proxy (Nginx) :

```nginx
server {
    listen 443 ssl;
    server_name 82.165.150.150;

    ssl_certificate /etc/letsencrypt/live/82.165.150.150/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/82.165.150.150/privkey.pem;

    location / {
        proxy_pass http://localhost:20080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

---

## Dépannage

### Problème : Erreur "Collections not found"

**Solution** :
1. Vérifiez que le fichier JSON est valide
2. Vérifiez que toutes les collections ont des IDs uniques
3. Réessayez l'importation

### Problème : Erreur "Invalid field ID"

**Solution** :
1. Les IDs de champs doivent faire entre 5 et 255 caractères
2. Utilisez uniquement des lettres minuscules, chiffres et tirets bas
3. Vérifiez le fichier JSON

### Problème : Erreur d'authentification

**Solution** :
1. Vérifiez que la collection `users` est de type `auth`
2. Vérifiez que `allowPhoneAuth` est `true`
3. Vérifiez que le PIN est hashé correctement

### Problème : Les relations ne fonctionnent pas

**Solution** :
1. Vérifiez que les `collectionId` sont corrects
2. Vérifiez que les collections liées existent
3. Vérifiez les règles d'accès (RLS)

### Problème : Pas de notifications en temps réel

**Solution** :
1. Vérifiez que WebSocket est activé
2. Vérifiez que l'abonnement utilise la bonne collection
3. Vérifiez les règles d'accès pour la collection

---

## Commandes utiles

### Arrêter PocketBase

```bash
# Ctrl+C dans le terminal
# Ou si c'est un service
sudo systemctl stop pocketbase
```

### Sauvegarder les données

```bash
# Les données sont dans pb_data/
cp -r pb_data pb_data_backup
```

### Restaurer les données

```bash
rm -rf pb_data
cp -r pb_data_backup pb_data
```

### Réinitialiser la base de données

```bash
rm -rf pb_data
./pocketbase serve
```

---

## Ressources

- **Documentation PocketBase** : https://pocketbase.io/docs/
- **API REST** : https://pocketbase.io/docs/api-records/
- **Dart SDK** : https://github.com/pocketbase/dart-sdk
- **Schéma JSON** : `pocketbase_schema_complete.json`

---

**Dernière mise à jour** : Juin 2026  
**Version** : 1.0
