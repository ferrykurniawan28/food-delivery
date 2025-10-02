import 'package:fooddelivery/features/restaurant/domain/entities/entities.dart';

/// Model class for OperatingHours with JSON serialization
class OperatingHoursModel extends OperatingHours {
  const OperatingHoursModel({
    required super.dayOfWeek,
    required super.openTime,
    required super.closeTime,
    super.isClosed = false,
  });

  /// Create OperatingHoursModel from OperatingHours entity
  factory OperatingHoursModel.fromEntity(OperatingHours entity) {
    return OperatingHoursModel(
      dayOfWeek: entity.dayOfWeek,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      isClosed: entity.isClosed,
    );
  }

  /// Create OperatingHoursModel from JSON
  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) {
    return OperatingHoursModel(
      dayOfWeek: json['dayOfWeek'] as String,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }

  /// Convert OperatingHoursModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'openTime': openTime,
      'closeTime': closeTime,
      'isClosed': isClosed,
    };
  }

  /// Create a copy with updated fields
  OperatingHoursModel copyWith({
    String? dayOfWeek,
    String? openTime,
    String? closeTime,
    bool? isClosed,
  }) {
    return OperatingHoursModel(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
