import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pocketbase_service.dart';
import '../models/models.dart';

class ChatScreen extends StatefulWidget {
  final String ticketId;
  const ChatScreen({super.key, required this.ticketId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToMessages();
  }

  void _loadMessages() async {
    final pb = Provider.of<PocketBaseService>(context, listen: false).pb;
    final result = await pb.collection('papo_support_messages').getList(
      filter: 'ticket = "${widget.ticketId}"',
      sort: 'created',
    );
    setState(() {
      _messages = result.items.map((m) => m.toJson()).toList();
    });
  }

  void _subscribeToMessages() {
     final pb = Provider.of<PocketBaseService>(context, listen: false).pb;
     pb.collection('papo_support_messages').subscribe('*', (e) {
       if (e.record != null && e.record!.getStringValue('ticket') == widget.ticketId) {
         setState(() {
           _messages.add(e.record!.toJson());
         });
       }
     });
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    final pb = Provider.of<PocketBaseService>(context, listen: false).pb;
    await pb.collection('papo_support_messages').create(body: {
      'ticket': widget.ticketId,
      'sender': pb.authStore.model.id,
      'content': _messageController.text,
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Support')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isMe = m['sender'] == Provider.of<PocketBaseService>(context, listen: false).pb.authStore.model.id;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.indigo : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m['content'],
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Votre message...'),
                  ),
                ),
                IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
