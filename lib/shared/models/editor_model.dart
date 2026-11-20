class EditorPortfolioItem {
  final String id;
  final String title;
  final String category; // 'reels', 'youtube', 'brand_ads', 'podcast'
  final String thumbnailUrl;
  final String? videoUrl;
  final int durationSec;
  final int viewCount;

  const EditorPortfolioItem({
    required this.id,
    required this.title,
    required this.category,
    required this.thumbnailUrl,
    this.videoUrl,
    required this.durationSec,
    required this.viewCount,
  });
}

class EditorReview {
  final String id;
  final String clientName;
  final String clientAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const EditorReview({
    required this.id,
    required this.clientName,
    required this.clientAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

class EditorModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String? headline;
  final String? bio;
  final double ratingAvg;
  final int ratingCount;
  final double startingPrice;
  final int completedProjectsCount;
  final int yearsExperience;
  final int avgDeliveryDays;
  final bool isVerified;
  final bool isAvailable;
  final List<String> specializations;
  final List<EditorPortfolioItem> portfolios;
  final List<EditorReview> reviews;

  const EditorModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.headline,
    this.bio,
    required this.ratingAvg,
    required this.ratingCount,
    required this.startingPrice,
    required this.completedProjectsCount,
    this.yearsExperience = 3,
    this.avgDeliveryDays = 2,
    this.isVerified = true,
    this.isAvailable = true,
    required this.specializations,
    this.portfolios = const [],
    this.reviews = const [],
  });
}
