import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pocketbase_service.dart';
import '../models/models.dart';

class TontineListScreen extends StatelessWidget {
  const TontineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbService = Provider.of<PocketBaseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Tontines')),
      body: FutureBuilder<List<Tontine>>(
        future: pbService.getTontines(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final tontines = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tontines.length,
            itemBuilder: (context, index) {
              final t = tontines[index];
              return Card(
                child: ListTile(
                  title: Text(t.name),
                  subtitle: Text('Cotisation: ${t.contributionAmount} - ${t.frequency}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to detail
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
