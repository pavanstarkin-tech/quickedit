import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ClientsSupportScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(String route)? onNavigate;

  const ClientsSupportScreen({super.key, this.onBack, this.onNavigate});

  @override
  State<ClientsSupportScreen> createState() => _ClientsSupportScreenState();
}

class _ClientsSupportScreenState extends State<ClientsSupportScreen> {
  int _selectedTab = 0; // 0: Active (2), 1: Completed (6), 2: Support

  final List<Map<String, dynamic>> _activeClients = [
    {
      'name': 'Maya Patel',
      'avatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
      'rating': 5.0,
      'orderCount': 3,
      'activeService': 'Insta Reel Edit',
      'due': 'Today, 7:30 PM',
      'orderId': '#QE2457',
    },
    {
      'name': 'Kabir Singhania',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      'rating': 4.9,
      'orderCount': 1,
      'activeService': 'YouTube Longform',
      'due': 'Tomorrow, 2:00 PM',
      'orderId': '#QE2458',
    },
  ];

  final List<Map<String, dynamic>> _supportTickets = [
    {
      'id': 'TK-102',
      'subject': 'Payment Clearance Inquiries for Order #QE2412',
      'status': 'Resolved',
      'date': '12 Nov 2026',
    },
    {
      'id': 'TK-105',
      'subject': 'Update IFSC code on bank account',
      'status': 'Open',
      'date': 'Yesterday',
    },
  ];

  void _showNewTicketDialog() {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contact Support Desk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject')),
            const SizedBox(height: 10),
            TextField(controller: messageController, maxLines: 3, decoration: const InputDecoration(labelText: 'Describe the issue...')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support ticket submitted! Support will respond within 2 hours.')),
              );
            },
            child: const Text('Create Ticket'),
          ),
        ],
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
        title: Text('Clients & Support', style: AppTypography.titleLarge()),
      ),
      body: Column(
        children: [
          // 3 Segmented Pills: Active (2), Completed (6), Support (Screen 12)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildSegmentButton('Active (2)', 0),
                const SizedBox(width: 8),
                _buildSegmentButton('Completed (6)', 1),
                const SizedBox(width: 8),
                _buildSegmentButton('Support', 2),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _selectedTab == 2 ? _buildSupportTab() : _buildClientsTab(),
          ),

          // Bottom Need Help Card (Screen 12)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border(top: BorderSide(color: AppColors.lightBorder)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.warmCream,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.headset_mic_outlined, color: AppColors.primaryOrange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Need Help?', style: AppTypography.titleMedium()),
                      Text('24/7 dedicated creator & client assistance', style: AppTypography.bodySmall()),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _showNewTicketDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textDark,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Contact Support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String title, int index) {
    final isSel = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSel ? AppColors.primaryOrange : AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel ? AppColors.primaryOrange : AppColors.lightBorder,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSel ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _activeClients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final c = _activeClients[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 24, backgroundImage: NetworkImage(c['avatar'])),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['name'], style: AppTypography.titleMedium()),
                    Text('${c['activeService']} • ${c['orderId']}', style: AppTypography.bodySmall(color: AppColors.primaryOrange)),
                    Text('Due: ${c['due']}', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => widget.onNavigate?.call('/workspace'),
                child: const Text('View Project'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSupportTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _supportTickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final t = _supportTickets[i];
        final isOpen = t['status'] == 'Open';
        return Container(
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
                        Text(t['id'], style: AppTypography.mono(color: AppColors.primaryOrange)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOpen ? AppColors.warningAmberBg : AppColors.successGreenBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t['status'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isOpen ? AppColors.warningAmberText : AppColors.successGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(t['subject'], style: AppTypography.labelLarge(color: AppColors.textDark)),
                    Text('Updated ${t['date']}', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.mutedGray),
            ],
          ),
        );
      },
    );
  }
}
