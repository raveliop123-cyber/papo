import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pocketbase_service.dart';
import '../models/models.dart';
import '../theme.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SOLDE ACTUEL',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Icon(Icons.waves_rounded, color: Colors.white.withOpacity(0.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${NumberFormat.currency(symbol: '').format(balance)} $currency',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '**** **** **** 8892',
                            style: GoogleFonts.sourceCodePro(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              letterSpacing: 2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'PAPO VIP',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
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

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: txs.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.05), height: 1),
          itemBuilder: (context, index) {
            final tx = txs[index];
            final isDeposit = tx.type == 'deposit';
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isDeposit ? Colors.green : Colors.orange).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isDeposit ? Icons.add_rounded : Icons.remove_rounded,
                      color: isDeposit ? Colors.green : Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.type == 'deposit' ? 'Dépôt Reçu' : 'Paiement Effectué',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          DateFormat.yMMMd().format(tx.created),
                          style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isDeposit ? '+' : '-'}${tx.amount} ${tx.currency}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDeposit ? Colors.green : Colors.black87,
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
