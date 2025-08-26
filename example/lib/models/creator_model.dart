import 'dart:convert';

class ContactCreatorModel {
  ContactCreatorModel({
    required this.countryCode,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.phone,
    required this.phoneIsoCodde,
    required this.userId,
  });

  factory ContactCreatorModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      ContactCreatorModel(
        countryCode: map['countryCode'] as String? ?? '',
        email: map['email'] as String? ?? '',
        firstName: map['firstName'] as String? ?? '',
        lastName: map['lastName'] as String? ?? '',
        name: map['name'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        phoneIsoCodde: map['phoneIsoCodde'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
      );

  factory ContactCreatorModel.fromJson(
    String source,
  ) =>
      ContactCreatorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String countryCode;
  final String email;
  final String firstName;
  final String lastName;
  final String name;
  final String phone;
  final String phoneIsoCodde;
  final String userId;

  String get fullName =>
      name.trim().isNotEmpty ? name : [firstName, lastName].join(' ').trim();

  ContactCreatorModel copyWith({
    String? countryCode,
    String? email,
    String? firstName,
    String? lastName,
    String? name,
    String? phone,
    String? phoneIsoCodde,
    String? userId,
  }) =>
      ContactCreatorModel(
        countryCode: countryCode ?? this.countryCode,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        phoneIsoCodde: phoneIsoCodde ?? this.phoneIsoCodde,
        userId: userId ?? this.userId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'countryCode': countryCode,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'name': name,
        'phone': phone,
        'phoneIsoCodde': phoneIsoCodde,
        'userId': userId,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ContactCreatorModel(countryCode: $countryCode, email: $email, firstName: $firstName, lastName: $lastName, name: $name, phone: $phone, phoneIsoCodde: $phoneIsoCodde, userId: $userId)';

  @override
  bool operator ==(covariant ContactCreatorModel other) {
    if (identical(this, other)) return true;

    return other.countryCode == countryCode &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.name == name &&
        other.phone == phone &&
        other.phoneIsoCodde == phoneIsoCodde &&
        other.userId == userId;
  }

  @override
  int get hashCode =>
      countryCode.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      phoneIsoCodde.hashCode ^
      userId.hashCode;
}
