/// This class is used for all the APIs endpoints
class IsmCallEndpoints {
  const IsmCallEndpoints._();

  static const String baseUrl = 'https://apis.isometrik.io';
  static const String wsUrl = 'wss://streaming.isometrik.io';

  static const String user = '/chat/user';

  static const String answerCall = '/agent/response';
  static const String endCall = '/chatQwik/agent/meeting/end';

  static const String getRecordings = '/chatQwik/agent/callRecording';
  static const String startRecording = '/meetings/v1/recording/start';
  static const String stopRecording = '/meetings/v1/recording/stop';

  /// apis for package
  static const String call = '/meetings/v1/meeting';
  static const String rejectCall = '/meetings/v1/reject';
  static const String acceptCall = '/meetings/v1/accept';
}
