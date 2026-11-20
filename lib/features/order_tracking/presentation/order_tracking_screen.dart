import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/models/booking_model.dart';

class OrderTrackingScreen extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback? onBack;

  const OrderTrackingScreen({
    super.key,
    required this.booking,
    this.onBack,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int _revisionsRemaining = 2;
  bool _isApproved = false;
  int _userRating = 5;
  final TextEditingController _reviewController = TextEditingController();

  void _showRevisionModal() {
    final noteController = TextEditingController();
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
            Text('Request a Revision', style: AppTypography.headlineLarge()),
            const SizedBox(height: 6),
            Text(
              'Specify timestamps and concrete edits (e.g., 00:18 adjust cuts). $_revisionsRemaining free revisions remaining.',
              style: AppTypography.bodySmall(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter your revision notes...',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_revisionsRemaining > 0) {
                    setState(() => _revisionsRemaining--);
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Revision request submitted to editor!')),
                  );
                },
                child: const Text('Submit Revision Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.successGreenBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.successGreen, size: 28),
              ),
              const SizedBox(height: 12),
              Text('Order Approved & Payment Released!', style: AppTypography.titleLarge()),
              const SizedBox(height: 6),
              Text(
                'Rate your experience with ${widget.booking.editorName ?? "your editor"}',
                style: AppTypography.bodySmall(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  return IconButton(
                    icon: Icon(
                      starNum <= _userRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setModalState(() => _userRating = starNum),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write a quick review about the edit quality, pacing, communication...',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _isApproved = true);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        title: Text('Order Tracking', style: AppTypography.titleLarge()),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card with In Progress pill (Screen 06)
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
                            Text(widget.booking.serviceName, style: AppTypography.titleMedium()),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _isApproved ? AppColors.successGreenBg : const Color(0xFFE6F4EA),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _isApproved ? 'Completed' : widget.booking.status.displayName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _isApproved ? AppColors.successGreen : const Color(0xFF137333),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.booking.orderCode} • Due in 5h 12m',
                          style: AppTypography.bodySmall(color: AppColors.mutedGray),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(widget.booking.totalAmount),
                    style: AppTypography.titleLarge(color: AppColors.primaryOrange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Horizontal Milestone Timeline Stepper (Screen 06)
            _buildTimelineCard(),

            const SizedBox(height: 20),

            // Preview Video (1st Draft) Player Card (Screen 06)
            Text('Preview Video (1st Draft)', style: AppTypography.titleMedium()),
            const SizedBox(height: 10),
            _buildVideoPlayerMock(),

            const SizedBox(height: 20),

            // Revisions Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history, color: AppColors.primaryOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Revisions Left: $_revisionsRemaining', style: AppTypography.labelLarge(color: AppColors.textDark)),
                        Text('2 free revisions included per booking.', style: AppTypography.bodySmall()),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _isApproved ? null : _showRevisionModal,
                    child: const Text('Request Revision'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Approve & Release Payment CTA (Screen 06)
            if (!_isApproved)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _showReviewModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Approve & Release Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

            const SizedBox(height: 14),

            // Chat grace notice
            Center(
              child: Text(
                'Project chat remains active for 48 hours after approval.',
                style: AppTypography.labelSmall(color: AppColors.mutedGray),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard() {
    final nodes = ['Booked', 'Editing', 'First Preview', 'Delivering'];
    final activeIndex = _isApproved ? 4 : 2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(nodes.length, (i) {
          final isPast = i < activeIndex;
          final isCurrent = i == activeIndex;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isPast || isCurrent ? AppColors.primaryOrange : AppColors.lightBorder,
                        ),
                      ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isPast
                            ? AppColors.primaryOrange
                            : (isCurrent ? AppColors.primaryOrange : AppColors.warmCream),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isPast || isCurrent ? AppColors.primaryOrange : AppColors.lightBorder,
                        ),
                      ),
                      child: Center(
                        child: isPast
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : (isCurrent
                                ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                                : null),
                      ),
                    ),
                    if (i < nodes.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isPast ? AppColors.primaryOrange : AppColors.lightBorder,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  nodes[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent ? AppColors.primaryOrange : AppColors.mutedGray,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVideoPlayerMock() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: AppColors.deepBlack,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Row(
              children: [
                const Icon(Icons.pause, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text('0:14 / 0:58', style: TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(width: 10),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.24,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.fullscreen, color: Colors.white, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
