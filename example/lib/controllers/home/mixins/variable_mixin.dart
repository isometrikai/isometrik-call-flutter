part of '../home_controller.dart';

mixin VariableMixin {
  String? currentPushToken;

  String? prevPushToken;

  final notesLimit = 20;
  var notesSkip = 0;
  var notesTotalCount = 0;

  var detailsNotesSkip = 0;
  var detailsNotesTotalCount = 0;

  final recordingsLimit = 10;
  var recordingsSkip = 0;
  var recordingsTotalCount = 0;

  var isDetailsNotesLoading = true;

  var isRecordingsLoading = true;

  final RxInt _selectedNavIndex = 0.obs;
  int get selectedNavIndex => _selectedNavIndex.value;
  set selectedNavIndex(int value) {
    if (selectedNavIndex == value) {
      return;
    }
    _selectedNavIndex.value = value;
  }

  final RxBool _isCallActive = false.obs;
  bool get isCallActive => _isCallActive.value;
  set isCallActive(bool value) {
    if (isCallActive == value) {
      return;
    }
    _isCallActive.value = value;
  }

  RefreshController _notesController(bool isDetails) =>
      isDetails ? detailsNotesController : notesController;

  var notesController = RefreshController(initialRefresh: false);

  var detailsNotesController = RefreshController(initialRefresh: false);

  var recordingsController = RefreshController(initialRefresh: false);

  final Rx<List<NoteModel>?> _notes = Rx<List<NoteModel>?>(null);
  List<NoteModel>? get notes => _notes.value;
  set notes(List<NoteModel>? value) {
    if (notes == value || identical(notes, value)) {
      return;
    }
    _notes.value = value;
  }

  Map<String, List<NoteModel>> allNotes = {};

  Map<String, ContactsModel> allContacts = {};

  Map<String, RecordingsList> allRecordings = {};

  final Rx<ActivityStatus> _isAvailable = ActivityStatus.online.obs;
  ActivityStatus get isAvailable => _isAvailable.value;
  set isAvailable(ActivityStatus value) {
    if (isAvailable == value) {
      return;
    }
    _isAvailable.value = value;
  }

  final RxString _profileImage = ''.obs;
  String get profileImage => _profileImage.value;
  set profileImage(String value) => _profileImage.value = value;

  // ------------- Create Contact ----------------

  final createContactKey = GlobalKey<FormState>();

  final addNoteKey = GlobalKey<FormState>();

  var firstNameTEC = TextEditingController();

  var lastNameTEC = TextEditingController();

  var phoneTEC = TextEditingController();

  IsmCallUserInfoModel? userInfoModel;

  Country get _kCountry => Country(
        countryCode: 'IN',
        phoneCode: '91',
        e164Sc: -1,
        displayName: 'India (IN)',
        displayNameNoCountryCode: 'India',
        geographic: false,
        level: -1,
        name: 'India',
        example: '',
        e164Key: '',
      );

  Country selectedCountry = Country(
    countryCode: 'IN',
    phoneCode: '91',
    e164Sc: -1,
    displayName: 'India (IN)',
    displayNameNoCountryCode: 'India',
    geographic: false,
    level: -1,
    name: 'India',
    example: '',
    e164Key: '',
  );

  var emailTEC = TextEditingController();

  var notesTEC = TextEditingController();

  // ------------- User Profile ----------------

  var nameTEC = TextEditingController();
}
