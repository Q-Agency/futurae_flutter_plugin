// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'futurae_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuturaeAccount _$FuturaeAccountFromJson(Map<String, dynamic> json) =>
    FuturaeAccount(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      ftApiServerBaseUrl: json['ft_api_server_base_url'] as String?,
      enrolled: json['enrolled'] as bool,
      deviceToken: json['device_token'] as String?,
      serviceId: json['service_id'] as String,
      deviceId: json['device_id'] as String?,
      serviceName: json['service_name'] as String,
      enrolledAt: json['enrolled_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      totpSeed: json['totp_seed'] as String?,
      encryptedDtTotp: json['encrypted_dt_totp'] as String?,
      serviceLogo: json['service_logo'] as String?,
      allowedFactors: (json['allowed_factors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sessions: (json['sessions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      logoutPending: json['logout_pending'] as bool?,
    );

Map<String, dynamic> _$FuturaeAccountToJson(FuturaeAccount instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'ft_api_server_base_url': instance.ftApiServerBaseUrl,
      'enrolled': instance.enrolled,
      'device_token': instance.deviceToken,
      'service_id': instance.serviceId,
      'device_id': instance.deviceId,
      'service_name': instance.serviceName,
      'enrolled_at': instance.enrolledAt,
      'updated_at': instance.updatedAt,
      'totp_seed': instance.totpSeed,
      'encrypted_dt_totp': instance.encryptedDtTotp,
      'service_logo': instance.serviceLogo,
      'allowed_factors': instance.allowedFactors,
      'sessions': instance.sessions,
      'logout_pending': instance.logoutPending,
    };
