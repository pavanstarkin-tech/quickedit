import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/booking_model.dart';

class ProjectWorkspaceScreen extends StatefulWidget {
  final BookingModel? booking;
  final VoidCallback? onBack;

  const ProjectWorkspaceScreen({
    super.key,
    this.booking,
    this.onBack,
  });

  @override
  State<ProjectWorkspaceScreen> createState() => _ProjectWorkspaceScreenState();
}

class _ProjectWorkspaceScreenState extends State<ProjectWorkspaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BookingModel _booking;

  // Interactive Checklist (Screen 09)
  final List<Map<String, dynamic>> _checklist = [
    {'title': 'Review raw assets and brief', 'done': true},
    {'title': 'Sync multi-cam audio and noise clean', 'done': true},
    {'title': 'Rough assembly cut', 'done': false},
    {'title': 'Add animated captions & transitions', 'done': false},
    {'title': 'Color grade & sound design', 'done': false},
    {'title': 'Render 1080p preview for client', 'done': false},
  ];

  final List<Map<String, String>> _messages = [
    {
      'sender': 'client',
      'text': 'Hi Rohan! Excited to work with you on this earbud reel.',
      'time': 'Yesterday, 6:30 PM',
    },
    {
      'sender': 'editor',
      'text': 'Hey Maya! Got your files. Footage looks super clean. I am aiming to have draft #1 ready by this evening.',
      'time': 'Yesterday, 7:15 PM',
    },
  ];

  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _booking = widget.booking ?? MockData.activeBookings.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'editor',
        'text': _chatController.text.trim(),
        'time': 'Just now',
      });
      _chatController.clear();
    });
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_booking.serviceName, style: AppTypography.titleMedium()),
            Text('Project Workspace', style: AppTypography.bodySmall(color: AppColors.mutedGray)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Client info strip & Deadline Countdown Banner (Screen 09)
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_booking.clientAvatar ?? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_booking.clientName, style: AppTypography.labelLarge(color: AppColors.textDark)),
                      Text('${_booking.orderCode} • ${CurrencyFormatter.format(_booking.totalAmount)}', style: AppTypography.bodySmall()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmberBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.timer_outlined, color: AppColors.warningAmberText, size: 14),
                      SizedBox(width: 4),
                      Text('5h 12m left', style: TextStyle(color: AppColors.warningAmberText, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4 Workspace Tabs (Overview, Files, Revisions, Messages) (Screen 09)
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryOrange,
            unselectedLabelColor: AppColors.mutedGray,
            indicatorColor: AppColors.primaryOrange,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Files (3)'),
              Tab(text: 'Revisions'),
              Tab(text: 'Messages'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildFilesTab(),
                _buildRevisionsTab(),
                _buildMessagesTab(),
              ],
            ),
          ),

          // Dual Bottom Actions (Upload Preview / Mark as Ready) (Screen 09)
          _buildBottomActionStrip(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Brief', style: AppTypography.titleMedium()),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Text(
              _booking.brief ?? 'No brief provided.',
              style: AppTypography.bodyMedium(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: 18),

          Text('Reference Links', style: AppTypography.titleMedium()),
          const SizedBox(height: 8),
          for (var link in _booking.referenceLinks)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: AppColors.primaryOrange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(link, style: const TextStyle(color: Colors.blue, fontSize: 13)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 18),

          // Interactive Checklist (Screen 09)
          Text('Editor Checklist', style: AppTypography.titleMedium()),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              children: List.generate(_checklist.length, (i) {
                final item = _checklist[i];
                return CheckboxListTile(
                  value: item['done'],
                  activeColor: AppColors.primaryOrange,
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 13,
                      decoration: item['done'] ? TextDecoration.lineThrough : null,
                      color: item['done'] ? AppColors.mutedGray : AppColors.textDark,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => item['done'] = val ?? false);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _booking.files.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final f = _booking.files[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file, color: AppColors.primaryOrange, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.fileName, style: AppTypography.labelLarge(color: AppColors.textDark)),
                    Text(f.formattedSize, style: AppTypography.bodySmall()),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColors.textDark),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading ${f.fileName} from Cloudflare R2...')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevisionsTab() {
    return Center(
      child: Text('No revision requests yet. Ready for 1st draft.', style: AppTypography.bodyMedium()),
    );
  }

  Widget _buildMessagesTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final msg = _messages[i];
              final isMe = msg['sender'] == 'editor';
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.textDark : AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isMe ? Colors.transparent : AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['text']!,
                        style: TextStyle(
                          color: isMe ? Colors.white : AppColors.textDark,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg['time']!,
                        style: TextStyle(
                          color: isMe ? Colors.white60 : AppColors.mutedGray,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: AppColors.surfaceWhite,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      hintText: 'Type project message...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primaryOrange),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border(top: BorderSide(color: AppColors.lightBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final res = await FilePicker.platform.pickFiles();
                    if (res != null && res.files.isNotEmpty) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Preview file ${res.files.first.name} uploaded to R2!'),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      }
                      return;
                    }
                  } catch (_) {}
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Presigned R2 video preview uploaded!')),
                    );
                  }
                },
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Upload Preview'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Project marked as Ready! Client notified for review.'),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('Mark as Ready'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
