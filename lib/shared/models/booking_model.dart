enum BookingStatus {
  pendingPayment,
  booked,
  accepted,
  editorDeclined,
  editing,
  firstPreview,
  revisionRequested,
  finalDelivery,
  completed,
  cancelled,
  disputed;

  String get displayName {
    switch (this) {
      case BookingStatus.pendingPayment:
        return 'Pending Payment';
      case BookingStatus.booked:
        return 'Booked';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.editorDeclined:
        return 'Editor Declined';
      case BookingStatus.editing:
        return 'In Progress';
      case BookingStatus.firstPreview:
        return '1st Draft Preview';
      case BookingStatus.revisionRequested:
        return 'Revision Requested';
      case BookingStatus.finalDelivery:
        return 'Final Delivery';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.disputed:
        return 'Disputed';
    }
  }
}

class BookingMediaItem {
  final String id;
  final String fileName;
  final int sizeBytes;
  final String mimeType;
  final double uploadProgress; // 0.0 to 1.0

  const BookingMediaItem({
    required this.id,
    required this.fileName,
    required this.sizeBytes,
    required this.mimeType,
    this.uploadProgress = 1.0,
  });

  String get formattedSize {
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    } else if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB';
    } else {
      return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

class BookingModel {
  final String id;
  final String orderCode; // #QE2457
  final String clientId;
  final String clientName;
  final String? clientAvatar;
  final String? editorId;
  final String? editorName;
  final String? editorAvatar;
  final String serviceName;
  final double totalAmount;
  final BookingStatus status;
  final DateTime deadline;
  final int freeRevisionsRemaining;
  final String? previewVideoUrl;
  final String? brief;
  final List<String> referenceLinks;
  final List<BookingMediaItem> files;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.orderCode,
    required this.clientId,
    required this.clientName,
    this.clientAvatar,
    this.editorId,
    this.editorName,
    this.editorAvatar,
    required this.serviceName,
    required this.totalAmount,
    required this.status,
    required this.deadline,
    this.freeRevisionsRemaining = 2,
    this.previewVideoUrl,
    this.brief,
    this.referenceLinks = const [],
    this.files = const [],
    required this.createdAt,
  });
}
