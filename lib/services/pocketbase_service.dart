import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class PocketBaseService extends ChangeNotifier {
  final PocketBase pb = PocketBase('http://82.165.150.150:20080/');

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => pb.authStore.isValid;

  Future<bool> login(String phone, String pin) async {
    try {
      final authData = await pb.collection('papo_users').authWithPassword(phone, pin);
      if (authData.record != null) {
        _currentUser = User.fromRecord(authData.record!.toJson());
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
    return false;
  }

  void logout() {
    pb.authStore.clear();
    _currentUser = null;
    notifyListeners();
  }

  Future<Wallet?> getWallet() async {
    try {
      final result = await pb.collection('papo_wallets').getFirstListItem('user = "${pb.authStore.model.id}"');
      return Wallet.fromRecord(result.toJson());
    } catch (e) {
      debugPrint('Error getting wallet: $e');
    }
    return null;
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final userId = pb.authStore.model.id;
      final result = await pb.collection('papo_transactions').getList(
        filter: 'sender = "$userId" || receiver = "$userId"',
        sort: '-created',
      );
      return result.items.map((item) => Transaction.fromRecord(item.toJson())).toList();
    } catch (e) {
      debugPrint('Error getting transactions: $e');
    }
    return [];
  }

  Future<List<Tontine>> getTontines() async {
    try {
      final result = await pb.collection('papo_tontines').getList(sort: '-created');
      return result.items.map((item) => Tontine.fromRecord(item.toJson())).toList();
    } catch (e) {
      debugPrint('Error getting tontines: $e');
    }
    return [];
  }

  // Real-time subscription example
  void subscribeToTransactions(Function(Transaction) onUpdate) {
    pb.collection('papo_transactions').subscribe('*', (e) {
      if (e.record != null) {
        onUpdate(Transaction.fromRecord(e.record!.toJson()));
      }
    });
  }
}
