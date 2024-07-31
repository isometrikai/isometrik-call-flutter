import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

part 'app_routes.dart';

/// Contains the list of pages or routes taken across the whole application.
/// This will prevent us in using context for navigation. And also providing
/// the blocs required in the next named routes.
///
/// [pages] : will contain all the pages in the application as a route
/// and will be used in the material app.
/// Will be ignored for test since all are static values and would not change.
class AppPages {
  static const initial = Routes.splash;

  static const _transitionDuration = Duration(milliseconds: 500);

  static final pages = <GetPage>[
    GetPage<SplashView>(
      name: SplashView.route,
      page: SplashView.new,
      binding: SplashBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<TermsConditionView>(
      name: TermsConditionView.route,
      page: TermsConditionView.new,
      binding: TermsBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<EmailLoginView>(
      name: EmailLoginView.route,
      page: EmailLoginView.new,
      binding: AuthBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<ResetPasswordView>(
      name: ResetPasswordView.route,
      page: ResetPasswordView.new,
      binding: AuthBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<ForgotPasswordView>(
      name: ForgotPasswordView.route,
      page: ForgotPasswordView.new,
      binding: AuthBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<VerifyOtpView>(
      name: VerifyOtpView.route,
      page: VerifyOtpView.new,
      binding: AuthBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<SelectAccountView>(
      name: SelectAccountView.route,
      page: SelectAccountView.new,
      binding: AuthBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<SelectApplicationView>(
      name: SelectApplicationView.route,
      page: SelectApplicationView.new,
      binding: AuthBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<HomeView>(
      name: HomeView.route,
      page: HomeView.new,
      binding: HomeBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<SearchContactView>(
      name: SearchContactView.route,
      page: SearchContactView.new,
      binding: ContactBinding(),
    ),
    GetPage<HistoryView>(
      name: HistoryView.route,
      page: HistoryView.new,
      binding: LogsBinding(),
    ),
    GetPage<ContactDetailsView>(
      name: ContactDetailsView.route,
      page: ContactDetailsView.new,
      binding: LogsBinding(),
    ),
    GetPage<SingleNoteView>(
      name: SingleNoteView.route,
      page: SingleNoteView.new,
      binding: LogsBinding(),
    ),
    GetPage<EditProfileView>(
      name: EditProfileView.route,
      page: EditProfileView.new,
      bindings: [
        HomeBinding(),
        // IsmCallMqttBinding(),
      ],
    ),
    GetPage<IncomingCallView>(
      name: IncomingCallView.route,
      page: IncomingCallView.new,
      bindings: [
        HomeBinding(),
        // IsmCallMqttBinding(),
      ],
    ),
    GetPage<NotesView>(
      name: NotesView.route,
      page: NotesView.new,
      binding: HomeBinding(),
    ),
    GetPage<AddNoteView>(
      name: AddNoteView.route,
      page: AddNoteView.new,
      binding: HomeBinding(),
    ),
    GetPage<VideoView>(
      name: VideoView.route,
      page: VideoView.new,
    ),
    ...IsmCallPages.pages,
  ];
}
