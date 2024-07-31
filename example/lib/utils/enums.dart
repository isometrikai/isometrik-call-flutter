import 'package:call_qwik_example/main.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

enum RequestType {
  get,
  post,
  put,
  patch,
  delete,
  upload;
}

enum CallImageType {
  asset,
  svg,
  file,
  network;
}

enum ActivityStatus {
  online(true),
  offline(false);

  factory ActivityStatus.fromString(String data) =>
      {
        ActivityStatus.online.name: ActivityStatus.online,
        ActivityStatus.offline.name: ActivityStatus.offline,
      }[data] ??
      ActivityStatus.offline;

  factory ActivityStatus.fromValue(bool data) =>
      {
        ActivityStatus.online.value: ActivityStatus.online,
        ActivityStatus.offline.value: ActivityStatus.offline,
      }[data] ??
      ActivityStatus.offline;

  const ActivityStatus(this.value);
  final bool value;
}

enum CallStatus {
  active,
  missed,
  requested,
  accepted,
  expired,
  ended,
  noMember;

  factory CallStatus.fromString(String data) =>
      {
        active.name.toLowerCase(): active,
        missed.name.toLowerCase(): missed,
        requested.name.toLowerCase(): requested,
        accepted.name.toLowerCase(): accepted,
        expired.name.toLowerCase(): expired,
        ended.name.toLowerCase(): ended,
        noMember.name.toLowerCase(): noMember,
      }[data.toLowerCase()] ??
      missed;
}

enum CallEmpty {
  logs(AssetConstants.callActive, CallStrings.emptyLogs),
  missedOpprtunity(
      AssetConstants.missedOpportunity, CallStrings.emptyMissedOpportunities),
  notes(AssetConstants.notes, CallStrings.emptyNotes),
  recordings(AssetConstants.recording, CallStrings.emptyRecordings),
  contacts(AssetConstants.contactActive, CallStrings.emptyContacts),
  searchContacts(AssetConstants.contactActive, '');

  const CallEmpty(this.icon, this.description);
  final String icon;
  final String description;

  String get label => switch (this) {
        CallEmpty.logs => 'No Logs',
        CallEmpty.missedOpprtunity => 'No Missed Opportunities',
        CallEmpty.notes => 'No Notes',
        CallEmpty.recordings => 'No Call Recordings',
        CallEmpty.contacts => 'No Contacts',
        CallEmpty.searchContacts => 'Enter to search contacts',
      };
}

enum ContactDetailsType {
  calls('Calls'),
  missedOpportunity('Missed Opportunity'),
  notes('Notes'),
  recordings('Recordings');

  const ContactDetailsType(this.label);
  final String label;
}

enum MenuOption {
  create('Create Contact'),
  addNote('Add Notes'),
  edit('Edit Contact'),
  delete('Delete Contact'),
  block('Block'),
  unblock('Unblock');

  const MenuOption(this.label);
  final String label;
}
