import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

class EditorEarningsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const EditorEarningsScreen({super.key, this.onBack});

  @override
  State<EditorEarningsScreen> createState() => _EditorEarningsScreenState();
}

class _EditorEarningsScreenState extends State<EditorEarningsScreen> {
  String _selectedPeriod = 'This Month';
  double _availableBalance = 18450.0;
  final double _pendingBalance = 7200.0;
  final double _lifetimeEarnings = 284500.0;

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Order #QE2457 — Insta Reel Edit',
      'date': 'Yesterday, 8:45 PM',
      'amount': 2499.0,
      'isCredit': true,
      'status': 'Available',
    },
    {
      'title': 'Withdrawal to Bank (HDFC ••4921)',
      'date': '05 Nov 2026, 11:20 AM',
      'amount': 10000.0,
      'isCredit': false,
      'status': 'Processed (UTR: 4312891)',
    },
    {
      'title': 'Order #QE2412 — YouTube Longform',
      'date': '02 Nov 2026, 4:10 PM',
      'amount': 3800.0,
      'isCredit': true,
      'status': 'Available',
    },
  ];

  void _showWithdrawalModal() {
    final amountController = TextEditingController(text: '10000');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Withdraw Earnings', style: AppTypography.headlineLarge()),
            const SizedBox(height: 6),
            Text(
              'Available to withdraw: ${CurrencyFormatter.format(_availableBalance)} (Min. ₹500)',
              style: AppTypography.bodySmall(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Withdrawal Amount (₹)',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance, color: AppColors.primaryOrange),
                  SizedBox(width: 10),
                  Text('Payout to: rohan.upi@okhdfcbank', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final reqAmount = double.tryParse(amountController.text) ?? 0;
                  if (reqAmount >= 500 && reqAmount <= _availableBalance) {
                    setState(() {
                      _availableBalance -= reqAmount;
                      _transactions.insert(0, {
                        'title': 'Withdrawal Request (rohan.upi)',
                        'date': 'Just now',
                        'amount': reqAmount,
                        'isCredit': false,
                        'status': 'Pending Admin Approval',
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Withdrawal request for ${CurrencyFormatter.format(reqAmount)} submitted!'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  }
                },
                child: const Text('Confirm Withdrawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack)
            : null,
        title: Text('Earnings', style: AppTypography.titleLarge()),
        actions: [
          DropdownButton<String>(
            value: _selectedPeriod,
            underline: const SizedBox(),
            items: ['This Month', 'Last 3 Months', 'This Year', 'All Time']
                .map((p) => DropdownMenuItem(value: p, child: Text(p, style: AppTypography.labelSmall())))
                .toList(),
            onChanged: (val) => setState(() => _selectedPeriod = val!),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vibrant Orange Hero Earnings Card (Screen 11)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Withdrawable Balance', style: AppTypography.bodySmall(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.format(_availableBalance),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Graphical indicator bars
                  Row(
                    children: List.generate(12, (index) {
                      final h = (index % 4 + 1) * 6.0 + 8.0;
                      return Expanded(
                        child: Container(
                          height: h,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(index > 8 ? 0.35 : 0.85),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 2-Column Ledger Summary Card (Screen 11: Pending vs Lifetime)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pending Clearance', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(_pendingBalance),
                          style: AppTypography.titleLarge(color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.lightBorder),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lifetime Earnings', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(_lifetimeEarnings),
                          style: AppTypography.titleLarge(color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payout Method Card (Screen 11)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance, color: AppColors.primaryOrange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payout Method (UPI)', style: AppTypography.labelLarge(color: AppColors.textDark)),
                        Text('rohan.upi@okhdfcbank', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Change', style: AppTypography.labelLarge(color: AppColors.primaryOrange)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Withdraw CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _availableBalance >= 500 ? _showWithdrawalModal : null,
                icon: const Icon(Icons.arrow_upward_rounded),
                label: const Text('Withdraw Earnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 26),

            // Recent Transactions List (Screen 11)
            Text('Recent Transactions', style: AppTypography.titleLarge()),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = _transactions[i];
                final bool isCredit = t['isCredit'];

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCredit ? AppColors.successGreenBg : const Color(0xFFFEF2F2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isCredit ? AppColors.successGreen : AppColors.errorRed,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['title'], style: AppTypography.labelLarge(color: AppColors.textDark)),
                            Text('${t['date']} • ${t['status']}', style: AppTypography.bodySmall()),
                          ],
                        ),
                      ),
                      Text(
                        '${isCredit ? "+" : "-"}${CurrencyFormatter.format(t['amount'])}',
                        style: AppTypography.labelLarge(
                          color: isCredit ? AppColors.successGreen : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
