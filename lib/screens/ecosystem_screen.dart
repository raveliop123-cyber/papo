import 'package:flutter/material.dart';

class EcosystemScreen extends StatelessWidget {
  const EcosystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Écosystème PAPO')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _ecoCard('PAPO Store', Icons.shopping_bag),
          _ecoCard('PAPO Delivery', Icons.delivery_dining),
          _ecoCard('PAPO Insurance', Icons.security),
          _ecoCard('Other Apps', Icons.apps),
        ],
      ),
    );
  }

  Widget _ecoCard(String name, IconData icon) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.indigo),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
