import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@immutable
class SessionModel extends Equatable {
  const SessionModel({
    this.isAlreadyOnboarding = false,
  });

  final bool isAlreadyOnboarding;

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [isAlreadyOnboarding];

  SessionModel copyWith({
    bool? isAlreadyOnboarding,
  }) {
    return SessionModel(
      isAlreadyOnboarding: isAlreadyOnboarding ?? this.isAlreadyOnboarding,
    );
  }
}
