class FuturaeLockConfiguration {
  final FuturaeLockConfigurationType type;
  final num? unlockDuration;
  final bool? invalidatedByBiometricsChange;

  FuturaeLockConfiguration({
    required this.type,
    this.unlockDuration,
    this.invalidatedByBiometricsChange,
  });

  Map<String, dynamic> toJson() => {
        'type': type.code,
        'unlockDuration': unlockDuration,
        'invalidatedByBiometricsChange': invalidatedByBiometricsChange,
      };
}

enum FuturaeLockConfigurationType {
  none(code: 1),
  biometricsOnly(code: 2),
  biometricsOrPasscode(code: 3),
  sdkPinWithBiometricsOptional(code: 4);

  final int code;

  const FuturaeLockConfigurationType({required this.code});
}
