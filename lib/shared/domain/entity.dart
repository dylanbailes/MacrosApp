import 'package:equatable/equatable.dart';

/// Base class for all domain models/entities.
/// 
/// Using Equatable for value equality comparisons.
abstract class Entity extends Equatable {
  const Entity();

  @override
  List<Object?> get props => [];

  /// Convert entity to a map (for serialization)
  Map<String, dynamic> toMap();

  /// Create a copy of the entity with updated fields
  Entity copyWith();
}
