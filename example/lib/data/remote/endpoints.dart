/// This class is used for all the APIs endpoints
class Endpoints {
  const Endpoints._();

  static const String baseUrl = 'https://apis.isometrik.io';

  static const String adminBaseUrl =
      'https://apinew.isometrik.ai/v1'; // 'https://service-apis.isometrik.io/v1';

  static const String wsUrl = 'wss://streaming.isometrik.io';

  static const String user = '/chat/user';

  static const String allUsers = '/chat/users';
  static const String userDetails = '$user/details';
  static const String authenticate = '$user/authenticate';

  static const String presignedurl = '/upload';

  static const String userSubscription = '/gs/v2/subscription';

  static const String sendOtp = '/agent/send/otp';
  static const String verifyOtp = '/agent/login/otp';

  static const String emailLogin = '/agent/login';

  static const String resetPassword = '/chatQwik/agent/resetPassword';

  static const String forgotPassword = '/chatQwik/agent/forgotPassword';

  static const String refreshToken = '/refreshToken';

  static const String editProfile = '/chatQwik/agent/profileUpdate';

  static const String answerCall = '/agent/response';

  static const String endCall = '/chatQwik/agent/meeting/end';

  static const String callLog = '/chatQwik/agent/callLogs';

  static const String contact = '/chatQwik/contact';

  static const String notes = '/chatQwik/notes';

  static const String block = '/block/status';

  static const String config = '/chatQwik/appConfig';
  static const String status = '/chatQwik/agent/status';
  static const String heartbeat = '/chatQwik/agent/heartbeat';

  static const String getRecordings = '/chatQwik/agent/callRecording';
  static const String startRecording = '/meetings/v1/recording/start';
  static const String stopRecording = '/meetings/v1/recording/stop';

  /// apis for package
  static const String call = '/meetings/v1/meeting';
  static const String rejectCall = '/meetings/v1/reject';
  static const String acceptCall = '/meetings/v1/accept';
}
