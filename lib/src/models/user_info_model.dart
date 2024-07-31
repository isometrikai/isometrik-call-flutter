import 'dart:convert';

class IsmCallUserInfoModel {
  IsmCallUserInfoModel({
    required this.userName,
    required this.userId,
    required this.userIdentifier,
    required this.imageUrl,
  });

  factory IsmCallUserInfoModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      IsmCallUserInfoModel(
        userName: map['name'] as String? ?? map['userName'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        userIdentifier: map['userIdentifier'] as String? ?? '',
        imageUrl: map['imageUrl'] as String? ?? '',
      );

  factory IsmCallUserInfoModel.fromJson(
    String source,
  ) =>
      IsmCallUserInfoModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String userName;
  final String userId;
  final String userIdentifier;
  final String imageUrl;

  IsmCallUserInfoModel copyWith({
    String? userName,
    String? userId,
    String? userIdentifier,
    String? imageUrl,
  }) =>
      IsmCallUserInfoModel(
        userName: userName ?? this.userName,
        userId: userId ?? this.userId,
        userIdentifier: userIdentifier ?? this.userIdentifier,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userName': userName,
        'userId': userId,
        'userIdentifier': userIdentifier,
        'imageUrl': imageUrl,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'IsmCallUserInfoModel(userName: $userName, userId: $userId, userIdentifier: $userIdentifier, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant IsmCallUserInfoModel other) {
    if (identical(this, other)) return true;

    return other.userName == userName && other.userId == userId && other.userIdentifier == userIdentifier && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => userName.hashCode ^ userId.hashCode ^ userIdentifier.hashCode ^ imageUrl.hashCode;
}
