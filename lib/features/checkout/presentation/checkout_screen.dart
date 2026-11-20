import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/verified_badge.dart';
import '../../../shared/models/editor_model.dart';
import '../../../shared/models/service_model.dart';

class CheckoutScreen extends StatefulWidget {
  final EditorModel editor;
  final ServiceModel service;
  final List<ServiceAddon> addons;
  final double totalAmount;
  final VoidCallback? onBack;
  final VoidCallback? onPaymentSuccess;

  const CheckoutScreen({
    super.key,
    required this.editor,
    required this.service,
    this.addons = const [],
    required this.totalAmount,
    this.onBack,
    this.onPaymentSuccess,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'upi';
  bool _isProcessing = false;

  void _handlePay() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() => _isProcessing = false);
      widget.onPaymentSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
        ),
        title: Text('Checkout & Payment', style: AppTypography.titleLarge()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Editor summary card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 24, backgroundImage: NetworkImage(widget.editor.avatarUrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.editor.name, style: AppTypography.titleMedium()),
                            const SizedBox(width: 4),
                            const VerifiedBadge(size: 14),
                          ],
                        ),
                        Text(widget.service.name, style: AppTypography.bodySmall()),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(widget.totalAmount),
                    style: AppTypography.titleMedium(color: AppColors.primaryOrange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Itemized Breakdown Card (Screen 05)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price Breakdown', style: AppTypography.titleMedium()),
                  const SizedBox(height: 12),
                  _buildRow('${widget.service.name} Edit', widget.service.defaultBasePrice),
                  for (var addon in widget.addons) _buildRow(addon.name, addon.price),
                  _buildRow('Platform Fee', 0),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: AppTypography.titleLarge()),
                      Text(
                        CurrencyFormatter.format(widget.totalAmount),
                        style: AppTypography.headlineLarge(color: AppColors.primaryOrange),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Amber Trust Callout with Padlock (Screen 05)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warningAmberBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.warningAmber.withOpacity(0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.warningAmberText, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Payment protected by QuickEdit — funds are credited to the editor\'s withdrawable balance only after you approve the final delivery.',
                      style: AppTypography.bodySmall(color: AppColors.warningAmberText),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Payment Methods Selector
            Text('Select Payment Method', style: AppTypography.titleMedium()),
            const SizedBox(height: 12),
            _buildPaymentOption('upi', 'UPI (Google Pay, PhonePe, Paytm)', Icons.account_balance_wallet_outlined),
            const SizedBox(height: 10),
            _buildPaymentOption('card', 'Credit / Debit Card (Visa, MasterCard, RuPay)', Icons.credit_card_outlined),
            const SizedBox(height: 10),
            _buildPaymentOption('wallet', 'NetBanking / Wallets', Icons.account_balance_outlined),

            const SizedBox(height: 28),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _handlePay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shield_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Pay ${CurrencyFormatter.format(widget.totalAmount)} Securely',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Trust Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user, color: AppColors.successGreen, size: 16),
                const SizedBox(width: 6),
                Text('100% Secure Payments • 256-Bit SSL Encrypted', style: AppTypography.labelSmall()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, num amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium(color: AppColors.textSecondary)),
          Text(CurrencyFormatter.format(amount), style: AppTypography.labelLarge(color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String id, String label, IconData icon) {
    final isSel = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSel ? AppColors.primaryOrange : AppColors.lightBorder,
            width: isSel ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSel ? AppColors.primaryOrange : AppColors.textDark),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTypography.labelLarge(color: AppColors.textDark))),
            Radio<String>(
              value: id,
              groupValue: _selectedPaymentMethod,
              activeColor: AppColors.primaryOrange,
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            ),
          ],
        ),
      ),
    );
  }
}
