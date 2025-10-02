import 'package:equatable/equatable.dart';

/// Entity representing operating hours for a restaurant
class OperatingHours extends Equatable {
  final String dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  const OperatingHours({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  @override
  List<Object?> get props => [dayOfWeek, openTime, closeTime, isClosed];
}
