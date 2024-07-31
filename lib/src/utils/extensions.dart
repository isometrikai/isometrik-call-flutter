import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';

extension IsmCallContextExtension on BuildContext {
  IsmCallExtension? get callExtension =>
      Theme.of(this).extension<IsmCallExtension>();

  IsmCallThemeData? get callTheme => callExtension?.theme;

  IsmCallPropertiesData? get properties => callExtension?.properties;

  IsmCallTranslationsData? get translations => callExtension?.translations;
}

extension IsmCallNullString on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  String get mask {
    if (this == null) {
      return '';
    }
    if (this!.length < 4) {
      return this!;
    }
    return this!.substring(0, 2) +
        '*' * (this!.length - 4) +
        this!.substring(this!.length - 2);
  }
}

extension IsmCallConfigExtension on IsmCallConfig {
  Map<String, String> get tokenHeader => {
        'Content-Type': 'application/json',
        'userToken': userConfig.userToken ?? '',
        'licenseKey': projectConfig.licenseKey ?? '',
        'appSecret': projectConfig.appSecret ?? '',
      };

  Map<String, String> ismCallAwsHeader(
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

extension MapExtension on Map<String, dynamic> {
  Map<String, dynamic> removeNullValues() {
    var result = <String, dynamic>{};
    for (var entry in entries) {
      var k = entry.key;
      var v = entry.value;
      if (v != null) {
        if (!v.runtimeType.toString().contains('List') &&
            v.runtimeType.toString().contains('Map')) {
          result[k] =
              MapExtension(v as Map<String, dynamic>).removeNullValues();
        } else {
          result[k] = v;
        }
      }
    }
    return result;
  }

  String makeQuery() {
    var res = [];
    for (var entry in removeNullValues().entries) {
      var key = entry.key;
      var value = entry.value;
      res.add('$key=$value');
    }
    return res.join('&');
  }
}

extension IsmCallColorExtension on Color {
  String get hexCode => '#${value.toRadixString(16)}';
}

extension IsmCallMaterialStateExtension on Set<WidgetState> {
  bool get isDisabled => any((e) => [WidgetState.disabled].contains(e));
}

extension IsmCallDurationExtension on Duration {
  String get formatTime {
    final h = inHours.toString().padLeft(2, '0');
    final m = (inMinutes % 60).toString().padLeft(2, '0');
    final s = (inSeconds % 60).toString().padLeft(2, '0');
    return [if (h != '00') h, m, s].join(':');
  }

  String get formatDuration {
    var h = inHours.toString().padLeft(2, '0');
    var m = (inMinutes % 60).toString().padLeft(2, '0');
    var s = (inSeconds % 60).toString().padLeft(2, '0');
    if (h != '00') {
      h = '$h Hours';
    }
    if (m != '00') {
      m = '$m Mins';
    }
    if (s != '00') {
      s = '$s Secs';
    }
    return [h, m, s].where((e) => e != '00').join(' ');
  }
}

extension IsmCallDoubleExtensions on double {
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

extension IsmCallDateExtensions on DateTime {
  String get ismCallRelativeDate {
    final diff =
        DateTime.now().ismCallDateOnly.difference(ismCallDateOnly).inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == 1) {
      return 'Yesterday';
    }
    return ismCallFormatDate;
  }

  String get ismCallFormatDate {
    final date = DateFormat('dd MMMM, yyyy');
    return date.format(this);
  }

  String get ismCallFormatDateTime {
    final date = DateFormat('dd MMM yyyy, hh:mm aa');
    return date.format(this);
  }

  String get ismCallRecordingName {
    final date = DateFormat('ddMMMyyyy-hh:mmaa');
    return date.format(this);
  }

  String get ismCallFormatTime {
    final date = DateFormat('hh:mm aa');
    return date.format(this);
  }

  DateTime get ismCallDateOnly => DateTime(year, month, day);
}

extension IsmCallIntExtension on int {
  String get ismCallFormatTime => Duration(seconds: this).formatTime;

  String get ismCallFormatDuration =>
      IsmCallDurationExtension(Duration(seconds: this)).formatDuration;
}

extension IsmCallRoomExtension on Room {
  bool get sharingMyScreen => localParticipant?.isScreenShareEnabled() ?? false;
}

extension IsmCallResponseExtension on IsmCallResponseModel {
  Map<String, dynamic> get ismCallbody => jsonDecode(data)['data'];

  List<dynamic> get ismCallbodyList =>
      statusCode == 204 ? [] : jsonDecode(data)['data'] ?? [];
}

extension IsmCallTextInputTypeExtension on TextInputType {
  Iterable<String>? get ismCallAutofillHints => switch (index) {
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
  Timeouts ismCallCopyWith({
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
