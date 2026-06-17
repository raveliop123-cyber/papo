import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pocketbase_service.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbService = Provider.of<PocketBaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PAPO Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              pbService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(pbService),
            const SizedBox(height: 24),
            const Text(
              'Actions Rapides',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            const Text(
              'Transactions Récentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTransactionList(pbService),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Tontines'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/tontines');
          if (index == 2) Navigator.pushNamed(context, '/support');
        },
      ),
    );
  }

  Widget _buildBalanceCard(PocketBaseService pbService) {
    return FutureBuilder<Wallet?>(
      future: pbService.getWallet(),
      builder: (context, snapshot) {
        final balance = snapshot.data?.balance ?? 0.0;
        final currency = snapshot.data?.currency ?? 'XOF';

        return Card(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solde disponible',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${NumberFormat.currency(symbol: '').format(balance)} $currency',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionIcon(context, Icons.send, 'NFC', () => Navigator.pushNamed(context, '/payment', arguments: 'nfc')),
        _actionIcon(context, Icons.qr_code_scanner, 'QR Code', () => Navigator.pushNamed(context, '/payment', arguments: 'qr')),
        _actionIcon(context, Icons.bluetooth, 'Bluetooth', () => Navigator.pushNamed(context, '/payment', arguments: 'bluetooth')),
        _actionIcon(context, Icons.admin_panel_settings, 'Admin', () => Navigator.pushNamed(context, '/admin')),
      ],
    );
  }

  Widget _actionIcon(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionList(PocketBaseService pbService) {
    return FutureBuilder<List<Transaction>>(
      future: pbService.getTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final txs = snapshot.data!;

        if (txs.isEmpty) return const Text('Aucune transaction récente');

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: txs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final tx = txs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: tx.type == 'deposit' ? Colors.green.shade100 : Colors.red.shade100,
                child: Icon(
                  tx.type == 'deposit' ? Icons.arrow_downward : Icons.arrow_upward,
                  color: tx.type == 'deposit' ? Colors.green : Colors.red,
                ),
              ),
              title: Text(tx.type.toUpperCase()),
              subtitle: Text(DateFormat.yMMMd().add_Hm().format(tx.created)),
              trailing: Text(
                '${tx.type == 'deposit' ? '+' : '-'}${tx.amount} ${tx.currency}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tx.type == 'deposit' ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
