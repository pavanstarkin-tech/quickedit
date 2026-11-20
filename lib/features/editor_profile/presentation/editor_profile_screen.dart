import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/verified_badge.dart';
import '../../../shared/models/editor_model.dart';

class EditorProfileScreen extends StatefulWidget {
  final EditorModel editor;
  final VoidCallback? onBack;
  final VoidCallback? onBookNow;

  const EditorProfileScreen({
    super.key,
    required this.editor,
    this.onBack,
    this.onBookNow,
  });

  @override
  State<EditorProfileScreen> createState() => _EditorProfileScreenState();
}

class _EditorProfileScreenState extends State<EditorProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPortfolioTab = 'All';

  final List<String> _portfolioCategories = [
    'All',
    'Reels',
    'YouTube',
    'Brand Ads',
    'Podcast',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editor = widget.editor;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Dark Showreel Video Header with Play Button & Actions
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppColors.deepBlack,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: widget.onBack ?? () => Navigator.maybePop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        editor.portfolios.isNotEmpty
                            ? editor.portfolios.first.thumbnailUrl
                            : 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=1200',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.45),
                      ),
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.video_camera_back, color: Colors.white70, size: 14),
                              SizedBox(width: 6),
                              Text('Showreel • 1:15', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Profile Body Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar, Name, Rating, Experience
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(editor.avatarUrl),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        editor.name,
                                        style: AppTypography.headlineLarge(),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    if (editor.isVerified) const VerifiedBadge(size: 18),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${editor.ratingAvg} (${editor.ratingCount} reviews)',
                                      style: AppTypography.labelLarge(color: AppColors.textDark),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 3-Column Stats Row (Screen 03)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.lightBorder),
                        ),
                        child: Row(
                          children: [
                            _buildStatItem('${editor.completedProjectsCount}+', 'Projects'),
                            Container(width: 1, height: 32, color: AppColors.lightBorder),
                            _buildStatItem('${editor.yearsExperience}+ Years', 'Experience'),
                            Container(width: 1, height: 32, color: AppColors.lightBorder),
                            _buildStatItem('${editor.avgDeliveryDays} Days', 'Avg. delivery'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tabs (Portfolio, About, Reviews)
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primaryOrange,
                        unselectedLabelColor: AppColors.mutedGray,
                        indicatorColor: AppColors.primaryOrange,
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(text: 'Portfolio'),
                          Tab(text: 'About'),
                          Tab(text: 'Reviews'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tab View Body
                      SizedBox(
                        height: 450,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Portfolio Tab
                            _buildPortfolioTab(),
                            // About Tab
                            _buildAboutTab(editor),
                            // Reviews Tab
                            _buildReviewsTab(editor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom CTA Bar (Screen 03)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14171411),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
                border: const Border(top: BorderSide(color: AppColors.lightBorder)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          CurrencyFormatter.format(editor.startingPrice),
                          style: AppTypography.headlineLarge(color: AppColors.primaryOrange),
                        ),
                        Text(
                          'Starting price',
                          style: AppTypography.bodySmall(color: AppColors.mutedGray),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: widget.onBookNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      child: const Row(
                        children: [
                          Text('Book this editor', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTypography.titleMedium()),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.bodySmall(color: AppColors.mutedGray)),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Pills
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _portfolioCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = _portfolioCategories[i];
              final isSel = _selectedPortfolioTab == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedPortfolioTab = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.textDark : AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: isSel ? AppColors.textDark : AppColors.lightBorder),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSel ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        // 3x2 Grid
        Expanded(
          child: GridView.builder(
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, idx) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.play_circle_fill, color: Colors.white, size: 38),
                    ),
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: Text(
                        '18.4K views',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab(EditorModel editor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Biography', style: AppTypography.titleMedium()),
          const SizedBox(height: 8),
          Text(
            editor.bio ?? 'Passionate video editor and storytelling artist.',
            style: AppTypography.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Text('Specialisations', style: AppTypography.titleMedium()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: editor.specializations.map((spec) {
              return Chip(
                label: Text(spec),
                backgroundColor: AppColors.surfaceWhite,
                side: const BorderSide(color: AppColors.lightBorder),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(EditorModel editor) {
    if (editor.reviews.isEmpty) {
      return Center(
        child: Text('No reviews yet', style: AppTypography.bodyMedium()),
      );
    }
    return ListView.separated(
      itemCount: editor.reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final rev = editor.reviews[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundImage: NetworkImage(rev.clientAvatar)),
                  const SizedBox(width: 8),
                  Text(rev.clientName, style: AppTypography.labelLarge(color: AppColors.textDark)),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text('${rev.rating}', style: AppTypography.labelSmall()),
                ],
              ),
              const SizedBox(height: 8),
              Text(rev.comment, style: AppTypography.bodyMedium(color: AppColors.textSecondary)),
            ],
          ),
        );
      },
    );
  }
}
