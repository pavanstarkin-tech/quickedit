class ServiceModel {
  final String id;
  final String slug;
  final String name;
  final String subtitle;
  final String description;
  final double defaultBasePrice;
  final int defaultTurnaroundHours;
  final int freeRevisionsLimit;
  final double extraRevisionPrice;

  const ServiceModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.defaultBasePrice,
    this.defaultTurnaroundHours = 48,
    this.freeRevisionsLimit = 2,
    this.extraRevisionPrice = 299.0,
  });
}

class ServiceAddon {
  final String id;
  final String slug;
  final String name;
  final String description;
  final double price;
  final int turnaroundReductionHours;

  const ServiceAddon({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.price,
    this.turnaroundReductionHours = 0,
  });
}
