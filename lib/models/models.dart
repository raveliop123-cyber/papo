/// Modèles de données pour l'application Papo
/// 
/// Ce fichier contient tous les modèles de données utilisés
/// pour représenter les entités de l'application.

import 'package:intl/intl.dart';

// ============================================================================
// UTILISATEUR
// ============================================================================

/// Modèle représentant un utilisateur Papo
class User {
  final String id;
  final String name;
  final String? avatar;
  final String phone;
  final String? email;
  final DateTime? dateOfBirth;
  final bool isVerified;
  final int kycLevel;
  final String userType; // individual, merchant, admin, support
  final bool isActive;
  final bool biometricEnabled;
  final String themePreference; // light, dark, system
  final String language;
  final String? country;
  final String? city;
  final Map<String, dynamic>? notificationSettings;
  final DateTime? lastLogin;
  final String accountStatus; // active, suspended, closed, pending_verification
  final DateTime created;
  final DateTime updated;

  User({
    required this.id,
    required this.name,
    this.avatar,
    required this.phone,
    this.email,
    this.dateOfBirth,
    this.isVerified = false,
    this.kycLevel = 0,
    this.userType = 'individual',
    this.isActive = true,
    this.biometricEnabled = false,
    this.themePreference = 'system',
    this.language = 'fr',
    this.country,
    this.city,
    this.notificationSettings,
    this.lastLogin,
    this.accountStatus = 'active',
    required this.created,
    required this.updated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'] ?? '',
      email: json['email'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      isVerified: json['is_verified'] ?? false,
      kycLevel: json['kyc_level'] ?? 0,
      userType: json['user_type'] ?? 'individual',
      isActive: json['is_active'] ?? true,
      biometricEnabled: json['biometric_enabled'] ?? false,
      themePreference: json['theme_preference'] ?? 'system',
      language: json['language'] ?? 'fr',
      country: json['country'],
      city: json['city'],
      notificationSettings: json['notification_settings'],
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      accountStatus: json['account_status'] ?? 'active',
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'is_verified': isVerified,
      'kyc_level': kycLevel,
      'user_type': userType,
      'is_active': isActive,
      'biometric_enabled': biometricEnabled,
      'theme_preference': themePreference,
      'language': language,
      'country': country,
      'city': city,
      'notification_settings': notificationSettings,
      'last_login': lastLogin?.toIso8601String(),
      'account_status': accountStatus,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}

// ============================================================================
// PORTEFEUILLE
// ============================================================================

/// Modèle représentant un portefeuille utilisateur
class Wallet {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final double? dailyLimit;
  final double? monthlyLimit;
  final bool isActive;
  final double? totalSpentToday;
  final double? totalSpentMonth;
  final DateTime created;
  final DateTime updated;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    this.dailyLimit,
    this.monthlyLimit,
    this.isActive = true,
    this.totalSpentToday,
    this.totalSpentMonth,
    required this.created,
    required this.updated,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'XOF',
      dailyLimit: (json['daily_limit'] as num?)?.toDouble(),
      monthlyLimit: (json['monthly_limit'] as num?)?.toDouble(),
      isActive: json['is_active'] ?? true,
      totalSpentToday: (json['total_spent_today'] as num?)?.toDouble(),
      totalSpentMonth: (json['total_spent_month'] as num?)?.toDouble(),
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'balance': balance,
      'currency': currency,
      'daily_limit': dailyLimit,
      'monthly_limit': monthlyLimit,
      'is_active': isActive,
      'total_spent_today': totalSpentToday,
      'total_spent_month': totalSpentMonth,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  String get formattedBalance => NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '$currency ',
  ).format(balance);
}

// ============================================================================
// TRANSACTION
// ============================================================================

/// Modèle représentant une transaction
class Transaction {
  final String id;
  final String senderId;
  final String receiverId;
  final double amount;
  final String currency;
  final String type; // deposit, withdrawal, transfer, payment, tontine_contribution, tontine_distribution
  final String status; // pending, completed, failed, cancelled, reversed
  final String method; // online, nfc, qr, bluetooth, manual
  final String? notes;
  final String? reference;
  final double? fee;
  final bool? offlineSync;
  final Map<String, dynamic>? metadata;
  final DateTime created;
  final DateTime updated;

  Transaction({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.status,
    required this.method,
    this.notes,
    this.reference,
    this.fee,
    this.offlineSync,
    this.metadata,
    required this.created,
    required this.updated,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      senderId: json['sender'] ?? '',
      receiverId: json['receiver'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'XOF',
      type: json['type'] ?? 'transfer',
      status: json['status'] ?? 'pending',
      method: json['method'] ?? 'online',
      notes: json['notes'],
      reference: json['reference'],
      fee: (json['fee'] as num?)?.toDouble(),
      offlineSync: json['offline_sync'],
      metadata: json['metadata'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': senderId,
      'receiver': receiverId,
      'amount': amount,
      'currency': currency,
      'type': type,
      'status': status,
      'method': method,
      'notes': notes,
      'reference': reference,
      'fee': fee,
      'offline_sync': offlineSync,
      'metadata': metadata,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  String get formattedAmount => NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '$currency ',
  ).format(amount);

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'completed':
        return 'Complétée';
      case 'failed':
        return 'Échouée';
      case 'cancelled':
        return 'Annulée';
      case 'reversed':
        return 'Inversée';
      default:
        return status;
    }
  }

  String get typeLabel {
    switch (type) {
      case 'deposit':
        return 'Dépôt';
      case 'withdrawal':
        return 'Retrait';
      case 'transfer':
        return 'Virement';
      case 'payment':
        return 'Paiement';
      case 'tontine_contribution':
        return 'Contribution Tontine';
      case 'tontine_distribution':
        return 'Distribution Tontine';
      default:
        return type;
    }
  }
}

// ============================================================================
// KYC
// ============================================================================

/// Modèle représentant un dossier KYC
class KYC {
  final String id;
  final String userId;
  final int level;
  final String documentType; // id_card, passport, driver_license, proof_of_address
  final String documentNumber;
  final String documentFile;
  final String selfieFile;
  final String? addressFile;
  final String status; // pending, approved, rejected, expired
  final String? rejectionReason;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final DateTime? expiresAt;
  final DateTime created;
  final DateTime updated;

  KYC({
    required this.id,
    required this.userId,
    required this.level,
    required this.documentType,
    required this.documentNumber,
    required this.documentFile,
    required this.selfieFile,
    this.addressFile,
    required this.status,
    this.rejectionReason,
    this.verifiedBy,
    this.verifiedAt,
    this.expiresAt,
    required this.created,
    required this.updated,
  });

  factory KYC.fromJson(Map<String, dynamic> json) {
    return KYC(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      level: json['level'] ?? 1,
      documentType: json['document_type'] ?? 'id_card',
      documentNumber: json['document_number'] ?? '',
      documentFile: json['document_file'] ?? '',
      selfieFile: json['selfie_file'] ?? '',
      addressFile: json['address_file'],
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejection_reason'],
      verifiedBy: json['verified_by'],
      verifiedAt: json['verified_at'] != null ? DateTime.parse(json['verified_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'level': level,
      'document_type': documentType,
      'document_number': documentNumber,
      'document_file': documentFile,
      'selfie_file': selfieFile,
      'address_file': addressFile,
      'status': status,
      'rejection_reason': rejectionReason,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
}

// ============================================================================
// TONTINE
// ============================================================================

/// Modèle représentant une tontine (cercle d'épargne)
class Tontine {
  final String id;
  final String name;
  final String? description;
  final String creatorId;
  final List<String> members;
  final double contributionAmount;
  final String frequency; // daily, weekly, biweekly, monthly
  final String type; // simple, hierarchical, mixed
  final DateTime startDate;
  final DateTime endDate;
  final String status; // recruiting, active, paused, completed, cancelled
  final double? totalCollected;
  final List<String>? distributionOrder;
  final int? currentRound;
  final DateTime created;
  final DateTime updated;

  Tontine({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.members,
    required this.contributionAmount,
    required this.frequency,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.totalCollected,
    this.distributionOrder,
    this.currentRound,
    required this.created,
    required this.updated,
  });

  factory Tontine.fromJson(Map<String, dynamic> json) {
    return Tontine(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      creatorId: json['creator'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      contributionAmount: (json['contribution_amount'] as num?)?.toDouble() ?? 0.0,
      frequency: json['frequency'] ?? 'monthly',
      type: json['type'] ?? 'simple',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'] ?? 'recruiting',
      totalCollected: (json['total_collected'] as num?)?.toDouble(),
      distributionOrder: json['distribution_order'] != null ? List<String>.from(json['distribution_order']) : null,
      currentRound: json['current_round'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator': creatorId,
      'members': members,
      'contribution_amount': contributionAmount,
      'frequency': frequency,
      'type': type,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'total_collected': totalCollected,
      'distribution_order': distributionOrder,
      'current_round': currentRound,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  String get formattedContribution => NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'XOF ',
  ).format(contributionAmount);

  int get memberCount => members.length;
}

// ============================================================================
// NOTIFICATION
// ============================================================================

/// Modèle représentant une notification
class Notification {
  final String id;
  final String userId;
  final String type; // transaction, tontine, kyc, support, security, ecosystem, promotion
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? readAt;
  final String? priority; // low, medium, high, critical
  final DateTime created;
  final DateTime updated;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    this.readAt,
    this.priority,
    required this.created,
    required this.updated,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      type: json['type'] ?? 'transaction',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      priority: json['priority'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'priority': priority,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}

// ============================================================================
// TICKET SUPPORT
// ============================================================================

/// Modèle représentant un ticket de support
class SupportTicket {
  final String id;
  final String userId;
  final String category; // transaction, account, security, technical, other
  final String subject;
  final String description;
  final String status; // open, in_progress, waiting_user, resolved, closed
  final String priority; // low, medium, high, critical
  final String? assignedTo;
  final int? resolutionTime;
  final int? rating;
  final DateTime? resolvedAt;
  final DateTime created;
  final DateTime updated;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    this.assignedTo,
    this.resolutionTime,
    this.rating,
    this.resolvedAt,
    required this.created,
    required this.updated,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      category: json['category'] ?? 'other',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      assignedTo: json['assigned_to'],
      resolutionTime: json['resolution_time'],
      rating: json['rating'],
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at']) : null,
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'category': category,
      'subject': subject,
      'description': description,
      'status': status,
      'priority': priority,
      'assigned_to': assignedTo,
      'resolution_time': resolutionTime,
      'rating': rating,
      'resolved_at': resolvedAt?.toIso8601String(),
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  String get statusLabel {
    switch (status) {
      case 'open':
        return 'Ouvert';
      case 'in_progress':
        return 'En cours';
      case 'waiting_user':
        return 'En attente';
      case 'resolved':
        return 'Résolu';
      case 'closed':
        return 'Fermé';
      default:
        return status;
    }
  }
}

// ============================================================================
// SERVICE
// ============================================================================

/// Modèle représentant un service de l'écosystème
class Service {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String downloadUrl;
  final String category; // payment, investment, insurance, credit, business, other
  final double? rating;
  final int? reviewsCount;
  final bool isActive;
  final int? order;
  final DateTime created;
  final DateTime updated;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.downloadUrl,
    required this.category,
    this.rating,
    this.reviewsCount,
    this.isActive = true,
    this.order,
    required this.created,
    required this.updated,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      downloadUrl: json['download_url'] ?? '',
      category: json['category'] ?? 'other',
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'],
      isActive: json['is_active'] ?? true,
      order: json['order'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'download_url': downloadUrl,
      'category': category,
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_active': isActive,
      'order': order,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}

// ============================================================================
// MARCHAND
// ============================================================================

/// Modèle représentant un marchand
class Merchant {
  final String id;
  final String userId;
  final String businessName;
  final String businessCategory; // retail, restaurant, services, online, other
  final String merchantCode;
  final String? qrCode;
  final double commissionRate;
  final double? totalSales;
  final bool isVerified;
  final bool isActive;
  final DateTime created;
  final DateTime updated;

  Merchant({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessCategory,
    required this.merchantCode,
    this.qrCode,
    required this.commissionRate,
    this.totalSales,
    this.isVerified = false,
    this.isActive = true,
    required this.created,
    required this.updated,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      businessName: json['business_name'] ?? '',
      businessCategory: json['business_category'] ?? 'other',
      merchantCode: json['merchant_code'] ?? '',
      qrCode: json['qr_code'],
      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['total_sales'] as num?)?.toDouble(),
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'business_name': businessName,
      'business_category': businessCategory,
      'merchant_code': merchantCode,
      'qr_code': qrCode,
      'commission_rate': commissionRate,
      'total_sales': totalSales,
      'is_verified': isVerified,
      'is_active': isActive,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}
