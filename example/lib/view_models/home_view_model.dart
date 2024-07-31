import 'dart:async';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class HomeViewModel {
  HomeViewModel(this._repository);
  final HomeRepository _repository;

  DBWrapper get _dbWrapper => Get.find();

  Future<AgentDetailsModel?> refreshToken({
    required String refreshToken,
    required String clientName,
  }) async {
    try {
      var res = await _repository.refreshToken(
        refreshToken: refreshToken,
        clientName: clientName,
      );
      if (res.hasError) {
        return null;
      }
      final data = res.body;
      final client = data['clientName'];
      final token = TokenModel.fromMap(data['token']);
      var agent = AgentDetailsModel.fromJson(
        await _dbWrapper.getSecuredValue(
          LocalKeys.agent,
        ),
      );
      agent = agent.copyWith(
        clientName: client,
        token: token,
      );
      await _dbWrapper.saveValueSecurely(
        LocalKeys.agent,
        agent.toJson(),
      );
      return agent;
    } catch (e, st) {
      CallLog.error('refreshToken $e, $st');
      return null;
    }
  }

  Future<PresignedModel?> getPresignedUrl({
    required bool showLoader,
    required String folder,
    required String fileName,
    required String contentType,
  }) async {
    try {
      var payload = {
        'source': folder,
        'fileName': fileName,
        'contentType': contentType,
      };
      var res = await _repository.getPresignedUrl(
        showLoader: showLoader,
        payload: payload,
      );
      if (res.hasError) {
        return null;
      }
      var data = (res.decode()['data'] as List? ?? []).first;
      return PresignedModel.fromMap(data);
    } catch (e, st) {
      CallLog.error('getPresignedUrl $e, $st');
      return null;
    }
  }

  Future<ResponseModel> updatePresignedUrl({
    required String presignedUrl,
    required Uint8List file,
    required String contentType,
    required String host,
  }) async {
    try {
      return _repository.updatePresignedUrl(
        presignedUrl: presignedUrl,
        file: file,
        contentType: contentType,
        host: host,
      );
    } catch (e, st) {
      CallLog.error('updatePresignedUrl $e, $st');
      return ResponseModel.error();
    }
  }

  Future<bool> editProfile({
    required String name,
    required String imageUrl,
  }) async {
    try {
      var res = await _repository.editProfile({
        'name': name,
        'userProfileUrl': imageUrl,
      });

      return !res.hasError;
    } catch (e, st) {
      CallLog.error('editProfile $e, $st');
      return false;
    }
  }

  Future<IsmAcceptCallModel?> answerCall({
    required String meetingId,
    required bool isAccepted,
  }) async {
    try {
      var res = await _repository.answerCall({
        'id': meetingId,
        'status': isAccepted ? 'Accepted' : 'Rejected',
        'meetingId': meetingId,
      });
      if (res.hasError) {
        return null;
      }
      if (isAccepted) {
        return IsmAcceptCallModel.fromMap(res.body);
      } else {
        return null;
      }
    } catch (e, st) {
      CallLog.error('answerCall $e, $st');
      return null;
    }
  }

  Future<bool> endCall(String id) async {
    try {
      var res = await _repository.endCall({
        'id': id,
      });
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('endCall $e, $st');
      return false;
    }
  }

  Future<bool> getStatus() async {
    try {
      var res = await _repository.getStatus();
      if (res.hasError) {
        return false;
      }
      var status = res.body['status'] as String? ?? '';
      return status == 'online';
    } catch (e, st) {
      CallLog.error('status $e, $st');
      return false;
    }
  }

  Future<bool> updateStatus({
    required String status,
  }) async {
    try {
      var res = await _repository.updateStatus({
        'status': status,
      });
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('status update $e, $st}');
      return false;
    }
  }

  Future<bool> heartbeat() async {
    try {
      var res = await _repository.heartbeat();
      return res.statusCode == 200;
    } catch (e, st) {
      CallLog.error('heart beat $e, $st');
      return false;
    }
  }

  Future<bool> addContact({
    required String teamId,
    required String userIdentifier,
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? countryCode,
    String? notes,
  }) async {
    try {
      var res = await _repository.updateContact(
        isNewContact: id == null,
        payload: {
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'userIdentifier': userIdentifier,
          'teamId': teamId,
          'phone': phone,
          'countryCode': countryCode,
          'email': email,
          'notes': notes,
        },
      );

      return !res.hasError;
    } catch (e, st) {
      CallLog.error('addContact $e, $st');
      return false;
    }
  }

  Future<bool> deleteContact({
    required String id,
    required String userIdentifier,
  }) async {
    try {
      var res = await _repository.deleteContact(
        {
          'id': id,
          'userIdentifier': userIdentifier,
        },
      );

      return !res.hasError;
    } catch (e, st) {
      CallLog.error('deleteContact $e, $st');
      return false;
    }
  }

  Future<bool> updatePushToken({
    required bool add,
    required String token,
  }) async {
    try {
      var res = await _repository.updatePushToken({
        'addApnsDeviceToken': add,
        'apnsDeviceToken': token,
      });
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('updatePushToken $e, $st');
      return false;
    }
  }

  Future<SystemConfig?> getConfig() async {
    try {
      var res = await _repository.getConfig();
      if (res.hasError) {
        return null;
      }

      return SystemConfig.fromMap(res.body);
    } catch (e, st) {
      CallLog.error('getConfig $e, $st');
      return null;
    }
  }

  Future<NotesList?> getNotes({
    required String id,
    int limit = 10,
    int skip = 0,
    bool? showLoader,
  }) async {
    try {
      var res = await _repository.getNotes(
        query: {
          'id': id,
          'skip': skip,
          'limit': limit,
        },
        showLoader: showLoader,
      );
      if (res.hasError) {
        return null;
      }

      var body = res.bodyList;
      if (body.isEmpty) {
        return [];
      }
      var notes = body.first['notes'] as List? ?? [];

      return notes
          .map((e) => NoteModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      CallLog.error('getNotes $e, $st');
      return null;
    }
  }

  Future<bool> addNote({
    required String id,
    required String projectId,
    String? meetingId,
    required String note,
  }) async {
    try {
      var res = await _repository.addNote(
        {
          'id': id,
          'createdUnderProjectId': projectId,
          'note': note,
          if (meetingId != null && meetingId.trim().isNotEmpty) ...{
            'meetingId': meetingId,
          },
        },
      );
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('addNote $e, $st');
      return false;
    }
  }

  Future<RecordingsList?> getRecordings({
    required String userId,
    int limit = 10,
    int skip = 0,
    bool? showLoader,
  }) async {
    try {
      var res = await _repository.getRecordings(
        {
          'userId': userId,
          'skip': skip,
          'limit': limit,
        },
      );
      if (res.hasError) {
        return null;
      }

      var body = res.bodyList;
      if (body.isEmpty) {
        return [];
      }
      var recordings = [];
      for (final item in body) {
        if (item['segmentRecordings'] != null) {
          recordings.addAll(item['segmentRecordings'] as List);
        }
      }

      return recordings
          .map((e) => RecordingModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      CallLog.error('getRecordings $e, $st');
      return null;
    }
  }

  Future<bool> startRecording(
    String meetingId,
  ) async {
    try {
      var res = await _repository.startRecording(
        meetingId,
      );
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('startRecording $e, $st');
      return false;
    }
  }

  Future<bool> stopRecording(
    String meetingId,
  ) async {
    try {
      var res = await _repository.stopRecording(
        meetingId,
      );
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('stopRecording $e, $st');
      return false;
    }
  }

  Future<ContactsModel?> getContact({
    // required String teamId,
    required String userId,
  }) async {
    try {
      var res = await _repository.getContact(
        // teamId: teamId,
        userId: userId,
      );
      if (res.statusCode == 204) {
        return null;
      }
      var data = res.decode()['data'] as List? ?? [];
      if (data.isEmpty) {
        return null;
      }
      return data
          .map((e) => ContactsModel.fromMap(e as Map<String, dynamic>))
          .toList()
          .first;
    } catch (e, st) {
      CallLog.error('getContact $e, $st');
      return null;
    }
  }

  Future<bool> blockOrUnblock({
    required String isometrikUserId,
    String? contactId,
    required bool isBlocked,
  }) async {
    try {
      var res = await _repository.blockOrUnblock(
        {
          'isometrikUserId': isometrikUserId,
          'contactUserId': contactId,
          'isBlocked': isBlocked,
          'blockLevel': 'client',
          'teamId': '',
        },
      );
      return !res.hasError;
    } catch (e, st) {
      CallLog.error('blockOrUnblock $e, $st');
      return false;
    }
  }
}
