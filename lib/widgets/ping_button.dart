import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PingButton extends StatefulWidget {
  const PingButton({super.key});

  @override
  State<PingButton> createState() => _PingButtonState();
}

class _PingButtonState extends State<PingButton> {
  bool _isPinging = false;

  Future<void> _testPing() async {
    setState(() => _isPinging = true);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(Uri.parse('http://82.165.150.150:20080/api/health')).timeout(const Duration(seconds: 5));
      stopwatch.stop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ping: ${stopwatch.elapsedMilliseconds}ms | Status: ${response.statusCode}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      stopwatch.stop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ping Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPinging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100, // Above bottom nav if present
      child: FloatingActionButton.small(
        heroTag: 'ping_test',
        onPressed: _isPinging ? null : _testPing,
        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        child: _isPinging
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Icon(Icons.network_check_rounded, color: Colors.white),
      ),
    );
  }
}
