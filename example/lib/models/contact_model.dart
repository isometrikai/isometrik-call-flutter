import 'dart:convert';

import 'package:call_qwik_example/main.dart';

class ContactsModel {
  const ContactsModel({
    required this.id,
    required this.isometrikUserId,
    required this.name,
    required this.userProfileUrl,
    required this.phone,
    required this.countryCode,
    required this.email,
    required this.notes,
    required this.isBlocked,
    required this.creatorDetails,
  });

  factory ContactsModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      ContactsModel(
        id: map['id'] as String,
        isometrikUserId: map['isometrikUserId'] as String,
        name: map['name'] as String? ?? '',
        userProfileUrl: map['userProfileUrl'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        countryCode: map['countryCode'] as String? ?? '',
        email: map['email'] as String? ?? '',
        notes: map['notes'] as String? ?? '',
        isBlocked: map['isBlocked'] as bool? ?? false,
        creatorDetails: map['creatorDetails'] != null
            ? ContactCreatorModel.fromMap(map['creatorDetails'])
            : null,
      );

  factory ContactsModel.fromJson(
    String source,
  ) =>
      ContactsModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  String get phoneNumber => '+$countryCode $phone';

  final String id;
  final String isometrikUserId;
  final String name;
  final String userProfileUrl;
  final String phone;
  final String countryCode;
  final String email;
  final String notes;
  final bool isBlocked;
  final ContactCreatorModel? creatorDetails;

  ContactsModel copyWith({
    String? id,
    String? isometrikUserId,
    String? name,
    String? userProfileUrl,
    String? phone,
    String? countryCode,
    String? email,
    String? notes,
    bool? isBlocked,
    ContactCreatorModel? creatorDetails,
  }) =>
      ContactsModel(
        id: id ?? this.id,
        isometrikUserId: isometrikUserId ?? this.isometrikUserId,
        name: name ?? this.name,
        userProfileUrl: userProfileUrl ?? this.userProfileUrl,
        phone: phone ?? this.phone,
        countryCode: countryCode ?? this.countryCode,
        email: email ?? this.email,
        notes: notes ?? this.notes,
        isBlocked: isBlocked ?? this.isBlocked,
        creatorDetails: creatorDetails ?? this.creatorDetails,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'isometrikUserId': isometrikUserId,
        'name': name,
        'userProfileUrl': userProfileUrl,
        'phone': phone,
        'countryCode': countryCode,
        'email': email,
        'notes': notes,
        'isBlocked': isBlocked,
        'creatorDetails': creatorDetails?.toMap(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallContactsModel(id: $id, isometrikUserId: $isometrikUserId, name: $name, userProfileUrl: $userProfileUrl, phone: $phone, countryCode: $countryCode, email: $email, notes: $notes, isBlocked: $isBlocked, creatorDetails: $creatorDetails)';

  @override
  bool operator ==(covariant ContactsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.isometrikUserId == isometrikUserId &&
        other.name == name &&
        other.userProfileUrl == userProfileUrl &&
        other.phone == phone &&
        other.countryCode == countryCode &&
        other.email == email &&
        other.notes == notes &&
        other.isBlocked == isBlocked &&
        other.creatorDetails == creatorDetails;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      isometrikUserId.hashCode ^
      name.hashCode ^
      userProfileUrl.hashCode ^
      phone.hashCode ^
      countryCode.hashCode ^
      email.hashCode ^
      notes.hashCode ^
      isBlocked.hashCode ^
      creatorDetails.hashCode;
}
