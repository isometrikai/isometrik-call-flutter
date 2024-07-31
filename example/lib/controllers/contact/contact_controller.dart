import 'package:call_qwik_example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactController extends GetxController {
  ContactController(this._viewModel);

  final ContactViewModel _viewModel;

  var contactsController = RefreshController(initialRefresh: false);
  var searchController = RefreshController(initialRefresh: false);

  var searchDebouncer = Debouncer(milliseconds: 500);

  var searchTEC = TextEditingController();

  final contactsLimit = 20;
  var contactsSkip = 0;
  var contactsTotalCount = 0;

  var searchSkip = 0;
  var searchTotalCount = 0;

  bool get hasQuery => searchTEC.text.trim().isNotEmpty;

  final RxList<ContactsList> _contacts = <ContactsList>[].obs;
  ContactsGroupList get contacts => _contacts;
  set contacts(ContactsGroupList value) {
    if (listEquals(value, _contacts)) {
      return;
    }
    _contacts.value = value;
  }

  final RxList<ContactsList> _searchList = <ContactsList>[].obs;
  ContactsGroupList get searchList => _searchList;
  set searchList(ContactsGroupList value) {
    if (listEquals(value, _searchList)) {
      return;
    }
    _searchList.value = value;
  }

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    if (value == isLoading) {
      return;
    }
    _isLoading.value = value;
  }

  final RxBool _isSearching = true.obs;
  bool get isSearching => _isSearching.value;
  set isSearching(bool value) {
    if (value == isSearching) {
      return;
    }
    _isSearching.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    _fetchContacts();
    // IsmCallUtility.updateLater(getContacts);
  }

  void _fetchContacts() async {
    isLoading = true;
    update([ContactView.updateId]);
    await getContacts();
    isLoading = false;
    update([ContactView.updateId]);
  }

  Future<void> getContacts([
    bool forPagination = false,
  ]) async {
    contactsSkip = forPagination
        ? (contactsSkip + contactsLimit) > contactsTotalCount
            ? contactsTotalCount
            : contactsSkip + contactsLimit
        : 0;
    var data = await _getContacts(
      skip: contactsSkip,
    );
    var tempLogs = [...contacts.flat];
    if (data.isNotEmpty) {
      if (forPagination) {
        tempLogs.addAll(data);
      } else {
        tempLogs = data;
      }
      contacts = _viewModel.parseContacts(tempLogs);
      contactsTotalCount = contacts.totalCount;
      if (forPagination) {
        contactsController.loadComplete();
      } else {
        contactsController.refreshCompleted();
        contactsController.resetNoData();
      }
    } else {
      contactsController.loadNoData();
      contactsController.refreshToIdle();
    }
  }

  void searchContacts([
    bool forPagination = false,
  ]) {
    update([SearchContactView.updateId]);
    searchDebouncer.run(
      () => _searchContacts(forPagination),
    );
  }

  Future<void> _searchContacts([
    bool forPagination = false,
  ]) async {
    update([SearchContactView.updateId]);
    isSearching = true;
    searchSkip = forPagination
        ? (searchSkip + contactsLimit) > searchTotalCount
            ? searchTotalCount
            : searchSkip + contactsLimit
        : 0;
    var data = await _getContacts(
      skip: searchSkip,
      query: searchTEC.text,
    );
    var tempLogs = [...searchList.flat];
    if (data.isNotEmpty) {
      if (forPagination) {
        tempLogs.addAll(data);
      } else {
        tempLogs = data;
      }
      searchList = _viewModel.parseContacts(tempLogs);
      searchTotalCount = searchList.totalCount;
      if (forPagination) {
        searchController.loadComplete();
      } else {
        searchController.refreshCompleted();
        searchController.resetNoData();
      }
    } else {
      if (!forPagination) {
        searchList = [];
        searchTotalCount = 0;
      }
      searchController.loadNoData();
      searchController.refreshToIdle();
    }
    isSearching = false;
  }

  Future<List<ContactsModel>> _getContacts({
    required int skip,
    String? query,
  }) =>
      _viewModel.getContacts(
        teamId: IsmCall.i.config?.userConfig.teamId ?? '',
        limit: contactsLimit,
        skip: skip,
        query: query,
      );
}
