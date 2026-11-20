import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/quickedit_logo.dart';

class AdminPortalScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AdminPortalScreen({super.key, this.onBack});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen> {
  String _selectedSection = 'Analytics';

  final List<String> _sections = [
    'Analytics',
    'KYC & Verification Queue (3)',
    'Bookings & Orders',
    'Withdrawal Approvals (2)',
    'Catalog & Services',
    'Disputes & Support',
    'Audit Logs',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Row(
        children: [
          // Dark Left Sidebar for Desktop/Tablet (Module 13)
          Container(
            width: 250,
            color: AppColors.darkBackground,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const QuickEditLogo(fontSize: 20, isDark: true),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('OPERATIONS ADMIN', style: TextStyle(color: AppColors.primaryOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView.separated(
                    itemCount: _sections.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, i) {
                      final s = _sections[i];
                      final isSel = _selectedSection == s;
                      return ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        tileColor: isSel ? AppColors.primaryOrange : Colors.transparent,
                        title: Text(
                          s,
                          style: TextStyle(
                            color: isSel ? Colors.white : const Color(0xFFC7BEB5),
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => setState(() => _selectedSection = s),
                      );
                    },
                  ),
                ),
                if (widget.onBack != null)
                  ElevatedButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Exit Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),

          // Main Admin Content Area
          Expanded(
            child: Scaffold(
              backgroundColor: AppColors.warmCream,
              appBar: AppBar(
                title: Text(_selectedSection, style: AppTypography.headlineLarge()),
                actions: [
                  IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryOrange,
                    child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildSectionContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent() {
    if (_selectedSection.startsWith('KYC')) {
      return _buildKycQueue();
    } else if (_selectedSection.startsWith('Withdrawal')) {
      return _buildWithdrawalApprovals();
    } else {
      return _buildAnalyticsOverview();
    }
  }

  Widget _buildAnalyticsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top 4 Metrics
        Row(
          children: [
            _buildStatCard('Gross Merchandise Value', CurrencyFormatter.format(428500), '+18.4% this week', AppColors.primaryOrange),
            const SizedBox(width: 14),
            _buildStatCard('Platform Net Revenue', CurrencyFormatter.format(64275), '15% Commission', AppColors.successGreen),
            const SizedBox(width: 14),
            _buildStatCard('Active In-Flight Orders', '38', '94% on-time SLA', AppColors.textDark),
            const SizedBox(width: 14),
            _buildStatCard('Pending KYC Queue', '3', 'Requires review', AppColors.warningAmber),
          ],
        ),

        const SizedBox(height: 24),

        Text('Recent System Audit Logs', style: AppTypography.titleLarge()),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: [
              _buildAuditRow('2026-11-20 09:12', 'Payment Captured', 'Booking #QE2457 ₹2,499 (Razorpay ID: pay_P1982a)', 'System'),
              const Divider(height: 1),
              _buildAuditRow('2026-11-20 08:45', 'Editor Verification Approved', 'Editor Priya Sharma approved by Admin ID #1', 'Admin'),
              const Divider(height: 1),
              _buildAuditRow('2026-11-20 07:30', 'Withdrawal Marked Paid', 'Payout ₹10,000 to Maya Patel (UTR: UTR841289)', 'Finance'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String sub, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.bodySmall(color: AppColors.mutedGray)),
            const SizedBox(height: 6),
            Text(value, style: AppTypography.titleLarge(color: accent)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditRow(String time, String action, String details, String actor) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Text(time, style: AppTypography.mono(color: AppColors.mutedGray, fontSize: 11)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.warmCream, borderRadius: BorderRadius.circular(6)),
            child: Text(action, style: AppTypography.labelSmall(color: AppColors.textDark)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(details, style: AppTypography.bodyMedium(color: AppColors.textSecondary))),
          Text(actor, style: AppTypography.labelSmall(color: AppColors.primaryOrange)),
        ],
      ),
    );
  }

  Widget _buildKycQueue() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pending Editor KYC Approvals', style: AppTypography.titleLarge()),
          const SizedBox(height: 12),
          ListTile(
            leading: const CircleAvatar(backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200')),
            title: const Text('Vikramaditya Rao (Aadhaar + Showreel)'),
            subtitle: const Text('Submitted 3 hours ago • 4 portfolio videos attached'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(onPressed: () {}, child: const Text('Reject')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text('Approve & Verify')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalApprovals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pending Editor Withdrawals', style: AppTypography.titleLarge()),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Rohan Mehta — ₹10,000.00'),
            subtitle: const Text('UPI: rohan.upi@okhdfcbank • Available Balance: ₹18,450'),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Enter UTR & Mark Paid'),
            ),
          ),
        ],
      ),
    );
  }
}
