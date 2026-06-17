import 'package:flutter_test/flutter_test.dart';
import 'package:papo_app/models/models.dart';

void main() {
  group('Model Tests', () {
    test('User model should parse correctly', () {
      final json = {
        'id': 'user123',
        'name': 'John Doe',
        'avatar': 'avatar.png',
        'phone': '+22501020304',
        'is_verified': true,
        'theme_preference': 'dark',
        'nfc_enabled': true,
      };
      final user = User.fromRecord(json);
      expect(user.id, 'user123');
      expect(user.name, 'John Doe');
      expect(user.isVerified, true);
    });

    test('Wallet model should parse correctly', () {
      final json = {
        'id': 'wallet123',
        'user': 'user123',
        'balance': 5000.5,
        'currency': 'XOF',
      };
      final wallet = Wallet.fromRecord(json);
      expect(wallet.balance, 5000.5);
      expect(wallet.currency, 'XOF');
    });

    test('Transaction model should parse correctly', () {
      final json = {
        'id': 'tx123',
        'sender': 'user1',
        'receiver': 'user2',
        'amount': 1000.0,
        'currency': 'XOF',
        'type': 'transfer',
        'status': 'completed',
        'method': 'nfc',
        'notes': 'Dinner',
        'created': '2024-01-01T12:00:00.000Z',
      };
      final tx = Transaction.fromRecord(json);
      expect(tx.amount, 1000.0);
      expect(tx.method, 'nfc');
    });
  });
}
