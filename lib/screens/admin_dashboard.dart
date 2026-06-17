import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Console Admin PAPO'),
        backgroundColor: Colors.indigo,
      ),
      body: Row(
        children: [
          _buildSidebar(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return NavigationRail(
      extended: true,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.people), label: Text('Utilisateurs')),
        NavigationRailDestination(icon: Icon(Icons.account_balance), label: Text('Transactions')),
        NavigationRailDestination(icon: Icon(Icons.support), label: Text('Support Tickets')),
        NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Configuration')),
      ],
      selectedIndex: 0,
      onDestinationSelected: (index) {},
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vue d\'ensemble', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          const SizedBox(height: 32),
          const Text('Activités Récentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildActivityTable(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _statCard('Total Utilisateurs', '1,240', Icons.person, Colors.blue),
        _statCard('Volume Transactions', '4.5M XOF', Icons.money, Colors.green),
        _statCard('Tickets Ouverts', '12', Icons.bug_report, Colors.orange),
        _statCard('Tontines Actives', '45', Icons.group, Colors.purple),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTable() {
    return Card(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Utilisateur')),
          DataColumn(label: Text('Action')),
          DataColumn(label: Text('Statut')),
        ],
        rows: List.generate(5, (index) => DataRow(cells: [
          DataCell(Text('TXN-$index')),
          const DataCell(Text('Jean Dupont')),
          const DataCell(Text('Transfert')),
          const DataCell(Chip(label: Text('Succès'), backgroundColor: Colors.greenAccent)),
        ])),
      ),
    );
  }
}
