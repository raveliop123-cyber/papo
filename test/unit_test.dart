import 'package:flutter_test/flutter_test.dart';
import 'package:papo_app/models/models.dart';

void main() {
  group('Model Tests - User', () {
    test('User.fromJson should parse correctly', () {
      final json = {
        'id': 'user123',
        'name': 'John Doe',
        'avatar': 'avatar.png',
        'phone': '+221771234567',
        'email': 'john@example.com',
        'is_verified': true,
        'kyc_level': 2,
        'user_type': 'individual',
        'is_active': true,
        'biometric_enabled': true,
        'theme_preference': 'dark',
        'language': 'fr',
        'country': 'SN',
        'city': 'Dakar',
        'account_status': 'active',
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, 'user123');
      expect(user.name, 'John Doe');
      expect(user.phone, '+221771234567');
      expect(user.isVerified, true);
      expect(user.kycLevel, 2);
      expect(user.userType, 'individual');
      expect(user.biometricEnabled, true);
      expect(user.themePreference, 'dark');
      expect(user.language, 'fr');
      expect(user.country, 'SN');
      expect(user.city, 'Dakar');
    });

    test('User.toJson should serialize correctly', () {
      final user = User(
        id: 'user123',
        name: 'John Doe',
        phone: '+221771234567',
        created: DateTime(2024, 1, 1),
        updated: DateTime(2024, 1, 15),
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['name'], 'John Doe');
      expect(json['phone'], '+221771234567');
      expect(json['is_verified'], false);
      expect(json['kyc_level'], 0);
    });
  });

  group('Model Tests - Wallet', () {
    test('Wallet.fromJson should parse correctly', () {
      final json = {
        'id': 'wallet123',
        'user': 'user123',
        'balance': 5000.5,
        'currency': 'XOF',
        'daily_limit': 500000.0,
        'monthly_limit': 5000000.0,
        'is_active': true,
        'total_spent_today': 100000.0,
        'total_spent_month': 500000.0,
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };

      final wallet = Wallet.fromJson(json);

      expect(wallet.id, 'wallet123');
      expect(wallet.userId, 'user123');
      expect(wallet.balance, 5000.5);
      expect(wallet.currency, 'XOF');
      expect(wallet.isActive, true);
      expect(wallet.dailyLimit, 500000.0);
      expect(wallet.monthlyLimit, 5000000.0);
    });

    test('Wallet.formattedBalance should format correctly', () {
      final wallet = Wallet(
        id: 'wallet123',
        userId: 'user123',
        balance: 50000.0,
        currency: 'XOF',
        created: DateTime(2024, 1, 1),
        updated: DateTime(2024, 1, 15),
      );

      expect(wallet.formattedBalance, contains('XOF'));
      expect(wallet.formattedBalance, contains('50'));
    });
  });

  group('Model Tests - Transaction', () {
    test('Transaction.fromJson should parse correctly', () {
      final json = {
        'id': 'tx123',
        'sender': 'user1',
        'receiver': 'user2',
        'amount': 1000.0,
        'currency': 'XOF',
        'type': 'transfer',
        'status': 'completed',
        'method': 'nfc',
        'notes': 'Dinner payment',
        'reference': 'REF123',
        'fee': 5.0,
        'offline_sync': false,
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-01T12:00:00.000Z',
      };

      final tx = Transaction.fromJson(json);

      expect(tx.id, 'tx123');
      expect(tx.senderId, 'user1');
      expect(tx.receiverId, 'user2');
      expect(tx.amount, 1000.0);
      expect(tx.currency, 'XOF');
      expect(tx.type, 'transfer');
      expect(tx.status, 'completed');
      expect(tx.method, 'nfc');
      expect(tx.fee, 5.0);
    });

    test('Transaction.statusLabel should return correct label', () {
      final tx = Transaction(
        id: 'tx123',
        senderId: 'user1',
        receiverId: 'user2',
        amount: 1000.0,
        currency: 'XOF',
        type: 'transfer',
        status: 'completed',
        method: 'online',
        created: DateTime(2024, 1, 1),
        updated: DateTime(2024, 1, 1),
      );

      expect(tx.statusLabel, 'Complétée');
    });

    test('Transaction.typeLabel should return correct label', () {
      final tx = Transaction(
        id: 'tx123',
        senderId: 'user1',
        receiverId: 'user2',
        amount: 1000.0,
        currency: 'XOF',
        type: 'transfer',
        status: 'completed',
        method: 'online',
        created: DateTime(2024, 1, 1),
        updated: DateTime(2024, 1, 1),
      );

      expect(tx.typeLabel, 'Virement');
    });

    test('Transaction.formattedAmount should format correctly', () {
      final tx = Transaction(
        id: 'tx123',
        senderId: 'user1',
        receiverId: 'user2',
        amount: 50000.0,
        currency: 'XOF',
        type: 'transfer',
        status: 'completed',
        method: 'online',
        created: DateTime(2024, 1, 1),
        updated: DateTime(2024, 1, 1),
      );

      expect(tx.formattedAmount, contains('XOF'));
      expect(tx.formattedAmount, contains('50'));
    });
  });

  group('Model Tests - KYC', () {
    test('KYC.fromJson should parse correctly', () {
      final json = {
        'id': 'kyc123',
        'user': 'user123',
        'level': 2,
        'document_type': 'id_card',
        'document_number': 'ID123456',
        'document_file': 'doc.pdf',
        'selfie_file': 'selfie.jpg',
        'status': 'approved',
        'verified_by': 'admin123',
        'verified_at': '2024-01-10T12:00:00.000Z',
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-10T12:00:00.000Z',
      };

      final kyc = KYC.fromJson(json);

      expect(kyc.id, 'kyc123');
      expect(kyc.userId, 'user123');
      expect(kyc.level, 2);
      expect(kyc.status, 'approved');
      expect(kyc.isExpired, false);
    });
  });

  group('Model Tests - Tontine', () {
    test('Tontine.fromJson should parse correctly', () {
      final json = {
        'id': 'tontine123',
        'name': 'Tontine Dakar 2024',
        'description': 'Épargne collective',
        'creator': 'user1',
        'members': ['user1', 'user2', 'user3'],
        'contribution_amount': 50000.0,
        'frequency': 'monthly',
        'type': 'simple',
        'start_date': '2024-01-01T00:00:00.000Z',
        'end_date': '2025-01-01T00:00:00.000Z',
        'status': 'active',
        'total_collected': 150000.0,
        'current_round': 1,
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };

      final tontine = Tontine.fromJson(json);

      expect(tontine.id, 'tontine123');
      expect(tontine.name, 'Tontine Dakar 2024');
      expect(tontine.creatorId, 'user1');
      expect(tontine.memberCount, 3);
      expect(tontine.contributionAmount, 50000.0);
      expect(tontine.frequency, 'monthly');
      expect(tontine.status, 'active');
    });

    test('Tontine.memberCount should return correct count', () {
      final tontine = Tontine(
        id: 'tontine123',
        name: 'Tontine Test',
        creatorId: 'user1',
        members: ['user1', 'user2', 'user3', 'user4'],
        contributionAmount: 50000.0,
        frequency: 'monthly',
        type: 'simple',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2025, 1, 1),
        status: 'active',
        created: DateTime(2024, 1, 1),
        updated: DateTime(2024, 1, 15),
      );

      expect(tontine.memberCount, 4);
    });
  });

  group('Model Tests - Notification', () {
    test('Notification.fromJson should parse correctly', () {
      final json = {
        'id': 'notif123',
        'user': 'user123',
        'type': 'transaction',
        'title': 'Transaction reçue',
        'body': 'Vous avez reçu 50000 XOF',
        'is_read': false,
        'priority': 'high',
        'created': '2024-01-15T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };

      final notif = Notification.fromJson(json);

      expect(notif.id, 'notif123');
      expect(notif.userId, 'user123');
      expect(notif.type, 'transaction');
      expect(notif.isRead, false);
      expect(notif.priority, 'high');
    });
  });

  group('Model Tests - SupportTicket', () {
    test('SupportTicket.fromJson should parse correctly', () {
      final json = {
        'id': 'ticket123',
        'user': 'user123',
        'category': 'transaction',
        'subject': 'Transaction échouée',
        'description': 'Ma transaction n\'a pas fonctionné',
        'status': 'open',
        'priority': 'high',
        'assigned_to': 'support1',
        'created': '2024-01-15T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };

      final ticket = SupportTicket.fromJson(json);

      expect(ticket.id, 'ticket123');
      expect(ticket.userId, 'user123');
      expect(ticket.category, 'transaction');
      expect(ticket.status, 'open');
      expect(ticket.priority, 'high');
    });

    test('SupportTicket.statusLabel should return correct label', () {
      final ticket = SupportTicket(
        id: 'ticket123',
        userId: 'user123',
        category: 'transaction',
        subject: 'Test',
        description: 'Test',
        status: 'open',
        priority: 'high',
        created: DateTime(2024, 1, 15),
        updated: DateTime(2024, 1, 15),
      );

      expect(ticket.statusLabel, 'Ouvert');
    });
  });

  group('Model Tests - Service', () {
    test('Service.fromJson should parse correctly', () {
      final json = {
        'id': 'service123',
        'name': 'Papo Pay',
        'description': 'Service de paiement',
        'icon': 'icon.png',
        'download_url': 'https://play.google.com/store/apps/details?id=com.papo.pay',
        'category': 'payment',
        'rating': 4.5,
        'reviews_count': 100,
        'is_active': true,
        'order': 1,
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };

      final service = Service.fromJson(json);

      expect(service.id, 'service123');
      expect(service.name, 'Papo Pay');
      expect(service.category, 'payment');
      expect(service.rating, 4.5);
      expect(service.isActive, true);
    });
  });

  group('Model Tests - Merchant', () {
    test('Merchant.fromJson should parse correctly', () {
      final json = {
        'id': 'merchant123',
        'user': 'user123',
        'business_name': 'Restaurant XYZ',
        'business_category': 'restaurant',
        'merchant_code': 'MERCHANT123',
        'qr_code': 'qr.png',
        'commission_rate': 2.5,
        'total_sales': 1000000.0,
        'is_verified': true,
        'is_active': true,
        'created': '2024-01-01T12:00:00.000Z',
        'updated': '2024-01-15T12:00:00.000Z',
      };

      final merchant = Merchant.fromJson(json);

      expect(merchant.id, 'merchant123');
      expect(merchant.userId, 'user123');
      expect(merchant.businessName, 'Restaurant XYZ');
      expect(merchant.isVerified, true);
      expect(merchant.commissionRate, 2.5);
    });
  });
}
