class User {
  final String id;
  final String name;
  final String avatar;
  final String phone;
  final bool isVerified;
  final String themePreference;
  final bool nfcEnabled;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phone,
    required this.isVerified,
    required this.themePreference,
    required this.nfcEnabled,
  });

  factory User.fromRecord(Map<String, dynamic> record) {
    return User(
      id: record['id'],
      name: record['name'] ?? '',
      avatar: record['avatar'] ?? '',
      phone: record['phone'] ?? '',
      isVerified: record['is_verified'] ?? false,
      themePreference: record['theme_preference'] ?? 'system',
      nfcEnabled: record['nfc_enabled'] ?? false,
    );
  }
}

class Wallet {
  final String id;
  final String userId;
  final double balance;
  final String currency;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
  });

  factory Wallet.fromRecord(Map<String, dynamic> record) {
    return Wallet(
      id: record['id'],
      userId: record['user'],
      balance: (record['balance'] as num).toDouble(),
      currency: record['currency'],
    );
  }
}

class Transaction {
  final String id;
  final String senderId;
  final String receiverId;
  final double amount;
  final String currency;
  final String type;
  final String status;
  final String method;
  final String notes;
  final DateTime created;

  Transaction({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.status,
    required this.method,
    required this.notes,
    required this.created,
  });

  factory Transaction.fromRecord(Map<String, dynamic> record) {
    return Transaction(
      id: record['id'],
      senderId: record['sender'],
      receiverId: record['receiver'],
      amount: (record['amount'] as num).toDouble(),
      currency: record['currency'],
      type: record['type'],
      status: record['status'],
      method: record['method'],
      notes: record['notes'] ?? '',
      created: DateTime.parse(record['created']),
    );
  }
}

class Tontine {
  final String id;
  final String name;
  final String description;
  final double contributionAmount;
  final String frequency;
  final String creatorId;
  final String status;

  Tontine({
    required this.id,
    required this.name,
    required this.description,
    required this.contributionAmount,
    required this.frequency,
    required this.creatorId,
    required this.status,
  });

  factory Tontine.fromRecord(Map<String, dynamic> record) {
    return Tontine(
      id: record['id'],
      name: record['name'],
      description: record['description'] ?? '',
      contributionAmount: (record['contribution_amount'] as num).toDouble(),
      frequency: record['frequency'],
      creatorId: record['creator'],
      status: record['status'],
    );
  }
}
