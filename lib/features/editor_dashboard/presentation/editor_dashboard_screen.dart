import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/quickedit_logo.dart';
import '../../../core/widgets/verified_badge.dart';

class EditorDashboardScreen extends StatefulWidget {
  final Function(String route)? onNavigate;

  const EditorDashboardScreen({super.key, this.onNavigate});

  @override
  State<EditorDashboardScreen> createState() => _EditorDashboardScreenState();
}

class _EditorDashboardScreenState extends State<EditorDashboardScreen> {
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 16,
          left: 16,
          right: 16,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: QUICKEDIT Logo & Profile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const QuickEditLogo(fontSize: 22, isDark: false),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.lightBorder),
                      ),
                      child: const Icon(Icons.notifications_none, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Greeting + Verified Badge + Availability Toggle (Screen 07)
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
                        Row(
                          children: [
                            Text('Good morning, Rohan', style: AppTypography.titleLarge()),
                            const SizedBox(width: 6),
                            const VerifiedBadge(size: 16),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isAvailable ? 'Available for work • Online' : 'Currently offline',
                          style: AppTypography.bodySmall(
                            color: _isAvailable ? AppColors.successGreen : AppColors.mutedGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isAvailable,
                    activeColor: AppColors.primaryOrange,
                    onChanged: (val) => setState(() => _isAvailable = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 3 KPI Cards Row (Screen 07: ₹18,450 Earnings, 12 Active, 4.9 Rating)
            Row(
              children: [
                _buildKpiCard('Earnings this month', CurrencyFormatter.format(18450), Icons.trending_up, AppColors.primaryOrange),
                const SizedBox(width: 10),
                _buildKpiCard('Active projects', '12', Icons.work_outline, AppColors.textDark),
                const SizedBox(width: 10),
                _buildKpiCard('Rating', '4.9 ★', Icons.star_border, Colors.amber),
              ],
            ),

            const SizedBox(height: 22),

            // 4 Quick-Action Tiles (Screen 07)
            Text('Quick Actions', style: AppTypography.titleLarge()),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildActionTile('New Job Requests', Icons.mark_email_unread_outlined, '3 Pending', () => widget.onNavigate?.call('/job-requests')),
                _buildActionTile('Calendar', Icons.calendar_month_outlined, '12 Deadlines', () => widget.onNavigate?.call('/calendar')),
                _buildActionTile('Earnings', Icons.account_balance_wallet_outlined, '₹18,450', () => widget.onNavigate?.call('/earnings')),
                _buildActionTile('My Profile', Icons.person_outline, 'Verified', () => widget.onNavigate?.call('/profile')),
              ],
            ),

            const SizedBox(height: 24),

            // Upcoming Deadlines List (Screen 07)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Deadlines', style: AppTypography.titleLarge()),
                TextButton(
                  onPressed: () => widget.onNavigate?.call('/calendar'),
                  child: Text('View All', style: AppTypography.labelLarge(color: AppColors.primaryOrange)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDeadlineItem('Insta Reel Edit', 'Maya Patel', 'Today, 7:30 PM', '5h 12m left', true),
            const SizedBox(height: 10),
            _buildDeadlineItem('YouTube Long Video', 'Kabir S.', 'Tomorrow, 2:00 PM', '1d 4h left', false),
            const SizedBox(height: 10),
            _buildDeadlineItem('Podcast Snippets (x3)', 'Siddharth Rao', 'Fri 15 Nov, 6:00 PM', '2d left', false),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.titleMedium(color: accentColor)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.mutedGray), maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
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
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryOrange, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: AppTypography.labelLarge(color: AppColors.textDark), maxLines: 1),
                  Text(subtitle, style: AppTypography.bodySmall(color: AppColors.mutedGray), maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineItem(String service, String client, String dueTime, String countdown, bool isUrgent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUrgent ? AppColors.primaryOrange.withOpacity(0.5) : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUrgent ? AppColors.warningAmberBg : AppColors.warmCream,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.schedule,
              color: isUrgent ? AppColors.warningAmberText : AppColors.textDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service, style: AppTypography.titleMedium()),
                Text('$client • Due $dueTime', style: AppTypography.bodySmall()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFEF2F2) : AppColors.warmCream,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              countdown,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isUrgent ? AppColors.errorRed : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
