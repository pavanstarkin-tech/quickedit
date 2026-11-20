import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

class JobRequestsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(Map<String, dynamic> job)? onOpenWorkspace;

  const JobRequestsScreen({
    super.key,
    this.onBack,
    this.onOpenWorkspace,
  });

  @override
  State<JobRequestsScreen> createState() => _JobRequestsScreenState();
}

class _JobRequestsScreenState extends State<JobRequestsScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _jobRequests = [
    {
      'id': 'job_101',
      'title': 'Insta Reel Edit — D2C Tech Gadget',
      'client': 'Maya Patel',
      'clientAvatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
      'category': 'Reels',
      'payout': 1200.0,
      'duration': '45 sec',
      'posted': '12 mins ago',
      'priority': 'Urgent',
      'brief': 'Need fast pacing cuts, zoom pops, sound effects on unboxing moments, and clean animated captions in orange brand tone.',
      'assetsCount': 3,
    },
    {
      'id': 'job_102',
      'title': 'YouTube Short — AI Tools Breakdown',
      'client': 'Arjun Mehta',
      'clientAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      'category': 'Shorts',
      'payout': 1100.0,
      'duration': '55 sec',
      'posted': '45 mins ago',
      'priority': 'High Priority',
      'brief': 'High retention cuts, hook in the first 2 seconds, dynamic motion background for text stats.',
      'assetsCount': 2,
    },
    {
      'id': 'job_103',
      'title': 'YouTube Longform — Travel Documentary',
      'client': 'Kavita Sen',
      'clientAvatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      'category': 'YouTube',
      'payout': 2800.0,
      'duration': '12 min',
      'posted': '2 hours ago',
      'priority': 'Standard',
      'brief': 'Cinematic color grading (teal & orange LUT), slow-motion drone b-rolls, sound design with atmospheric nature ambiance.',
      'assetsCount': 6,
    },
  ];

  void _handleAccept(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted "${job['title']}"! Opening project workspace...'),
        backgroundColor: AppColors.successGreen,
      ),
    );
    widget.onOpenWorkspace?.call(job);
  }

  void _handleDecline(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Request'),
        content: const Text('Are you sure? Declining too many requests within your working hours may impact your discovery score.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _jobRequests.removeAt(index));
            },
            child: const Text('Decline Job'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _jobRequests.where((j) {
      if (_selectedCategory == 'All') return true;
      return j['category'] == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack)
            : null,
        title: Text('New Job Requests', style: AppTypography.titleLarge()),
      ),
      body: Column(
        children: [
          // Filter Pills (Screen 08)
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'Reels', 'Shorts', 'YouTube'].map((cat) {
                final isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSel,
                    label: Text(cat),
                    selectedColor: AppColors.primaryOrange,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('No job requests in this category', style: AppTypography.bodyMedium()))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final job = filtered[i];
                      return _buildJobCard(job, i);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, int index) {
    final isUrgent = job['priority'] == 'Urgent';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? AppColors.primaryOrange.withOpacity(0.4) : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title, Priority Badge, Payout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title'], style: AppTypography.titleMedium()),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isUrgent ? AppColors.errorRedBg : AppColors.warningAmberBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            job['priority'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isUrgent ? AppColors.errorRedText : AppColors.warningAmberText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${job['duration']} • ${job['posted']}',
                          style: AppTypography.bodySmall(color: AppColors.mutedGray),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(job['payout']),
                    style: AppTypography.headlineLarge(color: AppColors.primaryOrange),
                  ),
                  Text('Net payout', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Client row & Brief excerpt
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundImage: NetworkImage(job['clientAvatar'])),
              const SizedBox(width: 6),
              Text(job['client'], style: AppTypography.labelSmall(color: AppColors.textDark)),
              const SizedBox(width: 10),
              Text('• ${job['assetsCount']} raw files attached', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            job['brief'],
            style: AppTypography.bodyMedium(color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Dual Action Buttons (Decline / Accept) (Screen 08)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleDecline(index),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark,
                    side: const BorderSide(color: AppColors.lightBorder),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleAccept(job),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accept Job'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
