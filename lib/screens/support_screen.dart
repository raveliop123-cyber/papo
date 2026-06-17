import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support & Aide')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('Réponse sous 48h garantie'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _supportItem(context, 'Mes tickets', Icons.history),
                  _supportItem(context, 'Nouveau ticket', Icons.add_comment),
                  _supportItem(context, 'Chat en direct', Icons.chat),
                  _supportItem(context, 'FAQ', Icons.question_answer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (title == 'Chat en direct') {
          Navigator.pushNamed(context, '/chat', arguments: 'support_ticket_default');
        }
      },
    );
  }
}
