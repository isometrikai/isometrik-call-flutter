import 'dart:convert';
import 'dart:math';

import 'package:call_qwik_example/main.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';

extension ConfigExtension on CallConfig {
  Map<String, String> get tokenHeader => {
        'Content-Type': 'application/json',
        'userToken': userConfig.userToken ?? '',
        'licenseKey': projectConfig.licenseKey ?? '',
        'appSecret': projectConfig.appSecret ?? '',
      };

  Map<String, String> awsHeader(
    String contentType,
    String host,
  ) =>
      {
        'Content-Type': contentType,
        'Host': host,
        'X-Amz-Acl': 'public-read',
      };

  Map<String, String> get authHeader => {
        ...tokenHeader,
        'Authorization': userConfig.accessToken ?? '',
      };

  Map<String, String> get projectHeader => {
        ...authHeader,
        'projectId': projectConfig.projectId ?? '',
      };
}

extension EditingExtension on TextEditingController {
  bool get isEmpty => text.trim().isEmpty;

  bool get isNotEmpty => text.trim().isNotEmpty;
}

extension DoubleExtensions on double {
  double get verticalPosition => Get.height * 1.1 * this;

  double get horizontalPosition {
    final random1 = Random().nextBool();
    final random2 = Random().nextBool();
    final value = random1
        ? random2
            ? 0.3
            : 0.4
        : random2
            ? 0.6
            : 0.7;
    return Get.width * 0.5 * this * value;
  }
}

extension DateExtensions on DateTime {
  String get relativeDate {
    final diff = DateTime.now().dateOnly.difference(dateOnly).inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == 1) {
      return 'Yesterday';
    }
    return formatDate;
  }

  String get formatDate {
    final date = DateFormat('dd MMMM, yyyy');
    return date.format(this);
  }

  String get formatDateTime {
    final date = DateFormat('dd MMM yyyy, hh:mm aa');
    return date.format(this);
  }

  String get recordingName {
    final date = DateFormat('ddMMMyyyy-hh:mmaa');
    return date.format(this);
  }

  String get formatTime {
    final date = DateFormat('hh:mm aa');
    return date.format(this);
  }

  DateTime get dateOnly => DateTime(year, month, day);
}

extension IntExtension on int {
  String get formatTime => Duration(seconds: this).formatTime;
}

extension ResponseExtension on ResponseModel {
  Map<String, dynamic> get body => jsonDecode(data)['data'];

  List<dynamic> get bodyList =>
      statusCode == 204 ? [] : jsonDecode(data)['data'] ?? [];
}

extension ActivityExtension on ActivityStatus {
  ActivityStatus get toggle {
    if (this == ActivityStatus.online) {
      return ActivityStatus.offline;
    }
    return ActivityStatus.online;
  }
}

extension TextInputTypeExtension on TextInputType {
  Iterable<String>? get autofillHints => switch (index) {
        3 => [AutofillHints.telephoneNumber],
        4 => [AutofillHints.birthdayDay],
        5 => [AutofillHints.email],
        6 => [AutofillHints.url],
        7 => [AutofillHints.password, AutofillHints.newPassword],
        8 => [
            AutofillHints.name,
            AutofillHints.newUsername,
            AutofillHints.namePrefix,
            AutofillHints.nameSuffix,
            AutofillHints.nickname,
            AutofillHints.givenName,
            AutofillHints.familyName,
            AutofillHints.givenName,
          ],
        _ => null,
      };
}

extension TimeoutExtension on Timeouts {
  Timeouts copyWith({
    Duration? connection,
    Duration? debounce,
    Duration? publish,
    Duration? peerConnection,
    Duration? iceRestart,
  }) =>
      Timeouts(
        connection: connection ?? this.connection,
        debounce: debounce ?? this.debounce,
        publish: publish ?? this.publish,
        peerConnection: peerConnection ?? this.peerConnection,
        iceRestart: iceRestart ?? this.iceRestart,
      );
}

extension GroupListExtension<T> on List<List<T>> {
  int get totalCount => fold(0, (a, b) => a + b.length);

  List<T> get flat => flattened.toList();
}

extension NavItemExtension on NavItem {
  Widget get screen => switch (this) {
        NavItem.calls => const LogsView(),
        NavItem.contacts => const ContactView(),
        NavItem.chats => const ChatView(),
        NavItem.profile => const ProfileView(),
      };
}

enum NavItem {
  calls(
    'Calls',
    AssetConstants.call,
    AssetConstants.callActive,
  ),
  contacts(
    'Contacts',
    AssetConstants.contact,
    AssetConstants.contactActive,
  ),
  chats(
    'Chats',
    AssetConstants.chat,
    AssetConstants.chatActive,
  ),
  profile(
    'Profile',
    AssetConstants.user,
    AssetConstants.userActive,
  );

  const NavItem(
    this.label,
    this.icon,
    this.activeIcon,
  );
  final String label;
  final String icon;
  final String activeIcon;

  static List<NavItem> get visible => [
        NavItem.calls,
        NavItem.contacts,
        // NavItem.chats,
        NavItem.profile,
      ];

  static List<Widget> get screens => visible.map((e) => e.screen).toList();
}

extension ContactDetailsTypeExtension on ContactDetailsType {
  Widget body(String userId) => switch (this) {
        ContactDetailsType.calls ||
        ContactDetailsType.missedOpportunity =>
          LogsAndOpportunity(
            isOpportunities: this == ContactDetailsType.missedOpportunity,
            userId: userId,
          ),
        ContactDetailsType.notes => ContactNotes(userId: userId),
        ContactDetailsType.recordings => ContactRecordings(userId: userId),
      };
}
