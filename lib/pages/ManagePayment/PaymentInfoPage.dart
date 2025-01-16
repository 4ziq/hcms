import 'package:flutter/material.dart';

class PaymentInfoPage extends StatelessWidget {
  final double totalAmount;

  const PaymentInfoPage({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: RM ${totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Enter payment details below'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment processing...')),
                );
                // Implement Stripe or other payment SDK here
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
