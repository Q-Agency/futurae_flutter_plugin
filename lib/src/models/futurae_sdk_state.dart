class FuturaeSdkState {
  final FuturaeSdkLockStatus lockStatus;
  final FuturaeSdkLockConfigStatus configStatus;
  final num? unlockedRemainingDuration;

  FuturaeSdkState(
      {required this.lockStatus,
      required this.configStatus,
      this.unlockedRemainingDuration});
}

enum FuturaeSdkLockStatus { locked, unlocked }

enum FuturaeSdkLockConfigStatus {
  valid,
  invalid,
  invalidBiometricsMissing,
  invalidBiometricsChanged,
  invalidPasscodeMissing,
  invalidPasscodeChanged
}
