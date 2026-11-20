import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/verified_badge.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/editor_model.dart';

class BrowseEditorsScreen extends StatefulWidget {
  final Function(EditorModel editor)? onSelectEditor;
  final VoidCallback? onBack;

  const BrowseEditorsScreen({
    super.key,
    this.onSelectEditor,
    this.onBack,
  });

  @override
  State<BrowseEditorsScreen> createState() => _BrowseEditorsScreenState();
}

class _BrowseEditorsScreenState extends State<BrowseEditorsScreen> {
  String _selectedFilter = 'Verified';
  String _searchQuery = '';

  final List<String> _filters = [
    'Verified',
    'Budget',
    'Delivery Time',
    'Rating',
    'Reels',
    'YouTube',
    'Color Grading',
  ];

  @override
  Widget build(BuildContext context) {
    final editors = MockData.editors.where((e) {
      if (_searchQuery.isNotEmpty) {
        return e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            e.specializations.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        title: Text('Find Video Editors', style: AppTypography.titleLarge()),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by editor name, skill, style...',
                prefixIcon: const Icon(Icons.search, color: AppColors.mutedGray),
                fillColor: AppColors.surfaceWhite,
              ),
            ),
          ),

          // Horizontally Scrollable Filter Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryOrange : AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryOrange : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (filter == 'Verified') ...[
                          Icon(
                            Icons.check,
                            size: 14,
                            color: isSelected ? Colors.white : AppColors.textDark,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          filter,
                          style: AppTypography.labelSmall(
                            color: isSelected ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        if (filter == 'Budget' || filter == 'Delivery Time' || filter == 'Rating') ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 14,
                            color: isSelected ? Colors.white : AppColors.textDark,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Editors List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: editors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final editor = editors[index];
                return _buildEditorCard(editor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorCard(EditorModel editor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06171411),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating, Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(editor.avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(editor.name, style: AppTypography.titleMedium()),
                        const SizedBox(width: 6),
                        if (editor.isVerified) const VerifiedBadge(size: 14),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${editor.ratingAvg} (${editor.ratingCount})',
                          style: AppTypography.labelSmall(color: AppColors.textDark),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '•  ${editor.completedProjectsCount} projects',
                          style: AppTypography.labelSmall(color: AppColors.mutedGray),
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
                    CurrencyFormatter.format(editor.startingPrice),
                    style: AppTypography.titleMedium(color: AppColors.primaryOrange),
                  ),
                  Text(
                    'Starting price',
                    style: AppTypography.bodySmall(color: AppColors.mutedGray),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 4 Portfolio Thumbnails Grid
          SizedBox(
            height: 72,
            child: Row(
              children: List.generate(4, (i) {
                final thumb = editor.portfolios.length > i
                    ? editor.portfolios[i].thumbnailUrl
                    : 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=300';
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(thumb),
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

          const SizedBox(height: 12),

          // Specialization Pills & View Profile Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: editor.specializations.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.warmCream,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 11, color: AppColors.textDark),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () => widget.onSelectEditor?.call(editor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
