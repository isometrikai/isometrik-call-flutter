import 'package:call_qwik_example/main.dart';

class ContactViewModel {
  ContactViewModel(this._repository);
  final ContactRepository _repository;

  Future<List<ContactsModel>> getContacts({
    required String teamId,
    int limit = 10,
    int skip = 0,
    String? query,
  }) async {
    try {
      var res = await _repository.getContacts(
        teamId: teamId,
        limit: limit,
        skip: skip,
        query: query,
      );
      if (res.statusCode == 204) {
        return [];
      }
      var data = res.decode()['data'] as List? ?? [];
      return data
          .map((e) => ContactsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      CallLog.error('get contacts $e, $st}');
      return [];
    }
  }

  ContactsGroupList parseContacts(ContactsList contacts) {
    var result = <String, List<ContactsModel>>{};
    for (var contact in contacts) {
      var letter = contact.name.toLowerCase().split('').first;
      result.update(
        letter,
        (value) => [...value, contact],
        ifAbsent: () => [contact],
      );
    }
    return result.values.toList();
  }
}
