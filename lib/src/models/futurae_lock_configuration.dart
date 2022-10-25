import 'package:equatable/equatable.dart';

class FuturaeLockConfiguration extends Equatable {
  final FuturaeLockConfigurationType type;
  final num? unlockDuration;
  final bool? invalidatedByBiometricsChange;

  const FuturaeLockConfiguration({
    required this.type,
    this.unlockDuration,
    this.invalidatedByBiometricsChange,
  });

  Map<String, dynamic> toJson() => {
        'type': type.code,
        'unlockDuration': unlockDuration,
        'invalidatedByBiometricsChange': invalidatedByBiometricsChange,
      };

  @override
  List<Object?> get props =>
      [type, unlockDuration, invalidatedByBiometricsChange];

  @override
  bool? get stringify => true;
}

enum FuturaeLockConfigurationType {
  none(code: 1),
  biometricsOnly(code: 2),
  biometricsOrPasscode(code: 3),
  sdkPinWithBiometricsOptional(code: 4);

  final int code;

  const FuturaeLockConfigurationType({required this.code});
}
