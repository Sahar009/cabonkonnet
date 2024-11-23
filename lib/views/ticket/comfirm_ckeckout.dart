import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final int ticketCount;
  final double ticketPrice; // Price per ticket

  const CheckoutPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.ticketCount,
    required this.ticketPrice,
  });

  @override
  Widget build(BuildContext context) {
    double total = ticketPrice * ticketCount;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBackBotton(
              pageTitle: "Checkout",
            ),
            30.toHeightWhiteSpacing(),
            Text(
              'Kindly confirm the information below',
              style: AppTextStyle.soraBody(
                size: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            30.toHeightWhiteSpacing(),
            _InfoRow(label: 'First name:', value: firstName),
            12.toHeightWhiteSpacing(),
            _InfoRow(label: 'Last name:', value: lastName),
            12.toHeightWhiteSpacing(),
            _InfoRow(label: 'Email:', value: email),
            12.toHeightWhiteSpacing(),
            _InfoRow(label: 'No. of tickets:', value: ticketCount.toString()),
            50.toHeightWhiteSpacing(),
            _InfoRow(
              label: 'Total:',
              value: '\$${total.toStringAsFixed(2)}',
              isBold: true,
            ),
            const Spacer(),
            AppButton(
              onTab: () {
                // Action when button is tapped (e.g., process payment)
                // You can navigate to a payment gateway or show a confirmation screen
              },
              title: "Check out",
            ),
            50.toHeightWhiteSpacing(),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
