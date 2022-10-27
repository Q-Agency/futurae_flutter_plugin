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
      enrolled: json['enrolled'] as bool?,
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
          ?.map((e) => SessionInfo.fromJson(e as Map<String, dynamic>))
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

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) => SessionInfo(
      userId: json['user_id'] as String,
      sessionId: json['session_id'] as String,
      sessionToken: json['session_token'] as String,
      serviceId: json['service_id'] as String,
      type: json['type'] as String,
      approveCombo: json['approve_combo'] as bool?,
      approveInfo: (json['approve_info'] as List<dynamic>?)
          ?.map((e) => ApproveInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      factor: json['factor'] as String?,
      timeout: json['timeout'] as num?,
    );

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'session_id': instance.sessionId,
      'session_token': instance.sessionToken,
      'service_id': instance.serviceId,
      'type': instance.type,
      'approve_combo': instance.approveCombo,
      'approve_info': instance.approveInfo,
      'factor': instance.factor,
      'timeout': instance.timeout,
    };

ApproveInfo _$ApproveInfoFromJson(Map<String, dynamic> json) => ApproveInfo(
      key: json['key'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ApproveInfoToJson(ApproveInfo instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };
