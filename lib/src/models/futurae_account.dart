import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'futurae_account.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FuturaeAccount extends Equatable {
  final String userId;
  final String username;
  final String? ftApiServerBaseUrl;
  final bool enrolled;
  final String? deviceToken;
  final String serviceId;
  final String? deviceId;
  final String serviceName;
  final String? enrolledAt;
  final String? updatedAt;
  final String? totpSeed;
  final String? encryptedDtTotp;
  final String? serviceLogo;
  final List<String>? allowedFactors;
  final List<String>? sessions;
  final bool? logoutPending;

  const FuturaeAccount(
      {required this.userId,
      required this.username,
      this.ftApiServerBaseUrl,
      required this.enrolled,
      this.deviceToken,
      required this.serviceId,
      this.deviceId,
      required this.serviceName,
      this.enrolledAt,
      this.updatedAt,
      this.totpSeed,
      this.encryptedDtTotp,
      this.serviceLogo,
      this.allowedFactors,
      this.sessions,
      this.logoutPending});

  factory FuturaeAccount.fromJson(Map<String, dynamic> json) =>
      _$FuturaeAccountFromJson(json);

  Map<String, dynamic> toJson() => _$FuturaeAccountToJson(this);

  @override
  List<Object?> get props => [
        userId,
        username,
        ftApiServerBaseUrl,
        enrolled,
        deviceToken,
        serviceId,
        deviceId,
        serviceName,
        enrolledAt,
        updatedAt,
        totpSeed,
        encryptedDtTotp,
        serviceLogo,
        allowedFactors,
        sessions,
        logoutPending
      ];

  @override
  bool? get stringify => true;
}
