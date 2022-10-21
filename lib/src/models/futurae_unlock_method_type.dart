enum FuturaeUnlockMethodType {
  biometric(number: 1),
  biometricsOrPasscode(number: 2),
  sdkPin(number: 3),
  none(number: 4);

  final int number;

  const FuturaeUnlockMethodType({required this.number});

  static FuturaeUnlockMethodType getByNumber(int number) {
    return FuturaeUnlockMethodType.values.firstWhere(
      (x) => x.number == number,
      orElse: () => FuturaeUnlockMethodType.none,
    );
  }
}
