import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String type; // 'nfc', 'qr', 'bluetooth'
  const PaymentScreen({super.key, required this.type});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  void _startPayment() {
    setState(() => _isProcessing = true);
    // Simulation logic
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paiement réussi !'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paiement ${widget.type.toUpperCase()}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.type == 'qr')
              QrImageView(
                data: "papo_payment_id_12345",
                version: QrVersions.auto,
                size: 200.0,
              ),
            if (widget.type == 'nfc')
              const Icon(Icons.nfc, size: 100, color: Colors.blue),
            if (widget.type == 'bluetooth')
              const Icon(Icons.bluetooth, size: 100, color: Colors.indigo),

            const SizedBox(height: 32),
            Text(
              _isProcessing ? 'Traitement en cours...' : 'Prêt pour le paiement',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProcessing ? null : _startPayment,
              child: Text('Simuler Paiement ${widget.type}'),
            ),
          ],
        ),
      ),
    );
  }
}
