import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pocketbase_service.dart';
import '../models/models.dart';
import '../theme.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbService = Provider.of<PocketBaseService>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, pbService),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(context, pbService),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Actions Rapides'),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Activités Récentes'),
                  const SizedBox(height: 16),
                  _buildTransactionList(pbService),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, PocketBaseService pbService) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'PAPO Pay',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            pbService.logout();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
    );
  }

  Widget _buildBalanceCard(BuildContext context, PocketBaseService pbService) {
    return FutureBuilder<Wallet?>(
      future: pbService.getWallet(),
      builder: (context, snapshot) {
        final balance = snapshot.data?.balance ?? 0.0;
        final currency = snapshot.data?.currency ?? 'XOF';
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isDark ? AppTheme.savannaNight : AppTheme.africanSunset,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Solde Total',
                          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.blur_on_rounded, color: Colors.white70, size: 30),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${NumberFormat.currency(symbol: '').format(balance)} $currency',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '**** **** **** 8892',
                      style: TextStyle(color: Colors.white70, fontSize: 18, letterSpacing: 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _actionItem(context, Icons.contactless_rounded, 'NFC', Colors.blue, 'nfc'),
        _actionItem(context, Icons.qr_code_2_rounded, 'QR Pay', Colors.orange, 'qr'),
        _actionItem(context, Icons.bluetooth_searching_rounded, 'BT Pay', Colors.indigo, 'bluetooth'),
        _actionItem(context, Icons.security_rounded, 'Admin', Colors.red, 'admin'),
      ],
    );
  }

  Widget _actionItem(BuildContext context, IconData icon, String label, Color color, String route) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (route == 'admin') {
               Navigator.pushNamed(context, '/admin');
            } else {
               Navigator.pushNamed(context, '/payment', arguments: route);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTransactionList(PocketBaseService pbService) {
    return FutureBuilder<List<Transaction>>(
      future: pbService.getTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final txs = snapshot.data!;

        if (txs.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                const Text('Aucune transaction', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: txs.length,
          itemBuilder: (context, index) {
            final tx = txs[index];
            final isDeposit = tx.type == 'deposit';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isDeposit ? Colors.green : Colors.red).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDeposit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: isDeposit ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.type.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          DateFormat.yMMMd().format(tx.created),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isDeposit ? '+' : '-'}${tx.amount} ${tx.currency}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDeposit ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'Tontines'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent_rounded), label: 'Support'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/tontines');
          if (index == 2) Navigator.pushNamed(context, '/support');
        },
      ),
    );
  }
}
