import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/quickedit_logo.dart';
import '../../../core/widgets/verified_badge.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/editor_model.dart';
import '../../../shared/models/service_model.dart';

class ClientHomeScreen extends StatelessWidget {
  final Function(String route)? onNavigate;
  final Function(EditorModel editor)? onSelectEditor;
  final Function(ServiceModel service)? onSelectService;

  const ClientHomeScreen({
    super.key,
    this.onNavigate,
    this.onSelectEditor,
    this.onSelectService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Cinematic Hero Banner
            _buildCinematicHero(context),

            const SizedBox(height: 24),

            // Service Category Grid (4 Cards from Screen 01)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Services',
                        style: AppTypography.titleLarge(),
                      ),
                      TextButton(
                        onPressed: () => onNavigate?.call('/browse'),
                        child: Text(
                          'View All',
                          style: AppTypography.labelLarge(
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildServiceCardsGrid(context),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Top Verified Editors Carousel (Screen 01)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Top Verified Editors',
                        style: AppTypography.titleLarge(),
                      ),
                      const SizedBox(width: 8),
                      const VerifiedBadge(size: 16),
                    ],
                  ),
                  TextButton(
                    onPressed: () => onNavigate?.call('/browse'),
                    child: Text(
                      'See All (24)',
                      style: AppTypography.labelLarge(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildTopVerifiedEditorsCarousel(context),

            const SizedBox(height: 28),

            // Recently Viewed / Recommended Editors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Featured Creators & Specialists',
                style: AppTypography.titleLarge(),
              ),
            ),
            const SizedBox(height: 12),
            _buildFeaturedEditorsList(context),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildCinematicHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.deepBlack,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        gradient: RadialGradient(
          center: Alignment(0.7, -0.6),
          radius: 1.2,
          colors: [
            Color(0xFF2E170A),
            AppColors.darkBackground,
            AppColors.deepBlack,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar with Logo, Notification Bell, Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const QuickEditLogo(fontSize: 22, isDark: true),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Hero Headline
          RichText(
            text: TextSpan(
              style: AppTypography.displayHero(),
              children: const [
                TextSpan(text: 'Turn Your Ideas Into\n'),
                TextSpan(
                  text: 'Amazing Videos',
                  style: TextStyle(
                    color: AppColors.secondaryOrange,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hire vetted video editors in minutes with guaranteed quality & fast delivery.',
            style: AppTypography.bodyMedium(color: const Color(0xFFC7BEB5)),
          ),

          const SizedBox(height: 20),

          // Search Bar
          GestureDetector(
            onTap: () => onNavigate?.call('/browse'),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white70, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search editors, reels, shorts, youtube...',
                      style: AppTypography.bodyMedium(color: Colors.white60),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCardsGrid(BuildContext context) {
    final services = MockData.services.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final service = services[index];
        IconData iconData = Icons.movie_filter_outlined;
        if (service.slug == 'insta_reel') iconData = Icons.camera_alt_outlined;
        if (service.slug == 'youtube_short') iconData = Icons.play_arrow_outlined;
        if (service.slug == 'youtube_long') iconData = Icons.smart_display_outlined;

        return InkWell(
          onTap: () => onSelectService?.call(service),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06171411),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warmCream,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(iconData, color: AppColors.primaryOrange, size: 20),
                    ),
                    Text(
                      CurrencyFormatter.format(service.defaultBasePrice),
                      style: AppTypography.labelLarge(color: AppColors.primaryOrange),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: AppTypography.titleMedium(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.subtitle,
                      style: AppTypography.bodySmall(color: AppColors.mutedGray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopVerifiedEditorsCarousel(BuildContext context) {
    final editors = MockData.editors;

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: editors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final editor = editors[index];
          return InkWell(
            onTap: () => onSelectEditor?.call(editor),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.lightBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08171411),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar, Name, Rating, Price
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(editor.avatarUrl),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    editor.name,
                                    style: AppTypography.titleMedium(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const VerifiedBadge(size: 14),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '${editor.ratingAvg} (${editor.ratingCount})',
                                  style: AppTypography.labelSmall(color: AppColors.textDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'From ${CurrencyFormatter.format(editor.startingPrice)}',
                    style: AppTypography.labelLarge(color: AppColors.primaryOrange),
                  ),
                  const SizedBox(height: 10),

                  // Mini Portfolio Thumbnails (3 thumbnails row)
                  Expanded(
                    child: Row(
                      children: List.generate(3, (tIndex) {
                        final thumbUrl = editor.portfolios.length > tIndex
                            ? editor.portfolios[tIndex].thumbnailUrl
                            : 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=300';
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: tIndex < 2 ? 6 : 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(thumbUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedEditorsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: MockData.editors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final editor = MockData.editors[index];
        return InkWell(
          onTap: () => onSelectEditor?.call(editor),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(editor.avatarUrl),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(editor.name, style: AppTypography.titleMedium()),
                          const SizedBox(width: 6),
                          const VerifiedBadge(size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        editor.headline ?? 'Video Creator & Editor',
                        style: AppTypography.bodySmall(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: editor.specializations.take(2).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warmCream,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(fontSize: 10, color: AppColors.textDark),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(editor.startingPrice),
                      style: AppTypography.labelLarge(color: AppColors.primaryOrange),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${editor.ratingAvg}',
                          style: AppTypography.labelSmall(color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
