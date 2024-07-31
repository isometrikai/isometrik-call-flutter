import 'dart:convert';

class ApplicationModel {
  ApplicationModel({
    required this.clientName,
    required this.businessName,
    required this.firstName,
    required this.lastName,
    required this.accountlogourl,
    required this.projectId,
    required this.projectName,
  });

  factory ApplicationModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      ApplicationModel(
        clientName: map['clientName'] as String? ?? '',
        businessName: map['businessName'] as String? ?? '',
        firstName: map['firstName'] as String? ?? '',
        lastName: map['lastName'] as String? ?? '',
        accountlogourl: map['accountlogourl'] as String? ?? '',
        projectId: map['projectId'] as String? ?? '',
        projectName: map['projectName'] as String? ?? '',
      );

  factory ApplicationModel.fromJson(
    String source,
  ) =>
      ApplicationModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  String get name => businessName.trim().isNotEmpty ? businessName.trim() : [firstName, lastName].join(' ').trim();

  final String clientName;
  final String businessName;
  final String firstName;
  final String lastName;
  final String accountlogourl;
  final String projectId;
  final String projectName;

  ApplicationModel copyWith({
    String? clientName,
    String? businessName,
    String? firstName,
    String? lastName,
    String? accountlogourl,
    String? projectId,
    String? projectName,
  }) =>
      ApplicationModel(
        clientName: clientName ?? this.clientName,
        businessName: businessName ?? this.businessName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        accountlogourl: accountlogourl ?? this.accountlogourl,
        projectId: projectId ?? this.projectId,
        projectName: projectName ?? this.projectName,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'clientName': clientName,
        'businessName': businessName,
        'firstName': firstName,
        'lastName': lastName,
        'accountlogourl': accountlogourl,
        'projectId': projectId,
        'projectName': projectName,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ApplicationModel(clientName: $clientName, businessName: $businessName, firstName: $firstName, lastName: $lastName, accountlogourl: $accountlogourl, projectId: $projectId, projectName: $projectName)';

  @override
  bool operator ==(covariant ApplicationModel other) {
    if (identical(this, other)) return true;

    return other.clientName == clientName &&
        other.businessName == businessName &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.accountlogourl == accountlogourl &&
        other.projectId == projectId &&
        other.projectName == projectName;
  }

  @override
  int get hashCode =>
      clientName.hashCode ^
      businessName.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      accountlogourl.hashCode ^
      projectId.hashCode ^
      projectName.hashCode;
}
