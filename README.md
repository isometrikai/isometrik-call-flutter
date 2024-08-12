# Isometrik Flutter Call SDK

`Isometrik Flutter Call SDK` is a package to support chat functionality for flutter projects

## Setup

For detailed setup instructions, please refer to the platform-specific guides and you need to add your project level platforms:

- [Android](./README_android.md)

- [iOS](./README_ios.md)

## Initialization

Before using the Isometrik Flutter Call SDK, you need to ensure the necessary initializations are done.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsmCall.i.setup();
  runApp(MyApp());
}
```

## Usage

The Isometrik Flutter Call SDK supports various use cases to enhance your chat functionality:

1. Configuration : Set the configuration for account ID, project ID, keyset ID, license key, app secret, user secret, MQTT host, and port.
2. Customization: Customize the chat UI by setting the chat theme, chat bubble color, and message bubble type
3. User Management: Manage users by setting the user ID, user name, and user avatar.
4. Configuration Objects: Create configuration objects for the app and user.
5. Start a Call: you'll need to integrate the `IsmCallView` widget into your application

##### Optional Parameters

- `meetingId` is the ID of the meeting.
- `audioOnly` indicates whether the call is audio-only.
- `userInfo` is the user information model.

```dart
    IsmCallView(
        meetingId: 'meetingId123',
        audioOnly: 'boolValue',
        userInfo : 'information model'
    ),
```

6. Initializes `IsmCall` with the given configuration and sets up necessary callbacks and triggers for call events.

#### Parameters:

- `config`: Configuration for IsmCall.
- `appLogo`: Logo widget.
- `enableLogs`: Whether logs are enabled.
- `enableMqttLogs`: Whether MQTT logs are enabled.
- `shouldInitializeMqtt`: Whether to initialize MQTT connection.
- `topics`: List of topics for MQTT.
- `topicChannels`: List of topic channels.
- `onLogout`: Logout function.
- `onRefreshToken`: Refresh token callback.
- `onAcceptCall`: Accept call trigger.
- `onDeclineCall`: Decline call trigger.
- `onEndCall`: End call trigger.
- `onRecording`: On recording trigger.

```dart
final config = IsmCallConfig(
  // configuration settings
);
await IsmCall.i.initialize(
  config,
  appLogo: LogoWidget(),
  enableLogs: true,
  enableMqttLogs: true,
  shouldInitializeMqtt: true,
  topics: ['topic1', 'topic2'],
  topicChannels: ['channel1', 'channel2'],
  onLogout: () async {
    // logout logic
  },
  onRefreshToken: (token) {
    // refresh token logic
  },
  onAcceptCall: (call) {
    // accept call logic
  },
  onDeclineCall: (call) {
    // decline call logic
  },
  onEndCall: (call) {
    // end call logic
  },
  onRecording: (call) {
    // on recording logic
  },
);

```

7.  Adds a listener for call triggers and returns a subscription to cancel the listener.

- `listener` - Function called when a call trigger is received.

```dart
final subscription = IsmCall.i.addCallTriggerListener((call) {
  // call trigger logic
});
// To cancel the listener
subscription.cancel();

```

8. Removes a previously added call trigger listener.

- `listener` - Function previously added as a listener.

```dart
final listener = (call) {
  // call trigger logic
};
IsmCall.i.addCallTriggerListener(listener);
// Later, to remove the listener
await IsmCall.i.removeCallTriggerListener(listener);

```

9. Adds a listener for call events and returns a subscription to cancel the listener.

- `listener` - Function called when a call event is received.

```dart
final subscription = IsmCall.i.addEventListener((event) {
  // call event logic
});
// To cancel the listener
subscription.cancel();

```

10. Removes a listener for call maps that was previously added.

- `listener` - Function previously added as a listener.

```dart
final listener = (callMap) {
  // call map logic
};
IsmCall.i.addListener(listener);
// Later, to remove the listener
await IsmCall.i.removeListener(listener);


```

11. Listens to an MQTT event.

- `event` - Event model containing MQTT event data.

```dart
final event = EventModel(
  topic: 'topic',
  payload: 'payload',
);
IsmCall.i.listenMqttEvent(event);

```

12. Starts a call with the provided meeting ID, call, and user info.

#### Parameters:

- `meetingId`: ID of the meeting.
- `call`: Call model containing call data.
- `userInfo`: User info model containing user data.
- `callType`: Type of the call (default is IsmCallType.audio).
- `callActions`: List of widgets displayed as call actions.
- `imageUrl`: URL of the image displayed during the call.
- `hdBroadcast`: Whether to broadcast in high definition (default is false).

```dart
final meetingId = 'meetingId';
final call = IsmAcceptCallModel(
  callerId: 'callerId',
  callerName: 'callerName',
);
final userInfo = IsmCallUserInfoModel(
  userId: 'userId',
  userName: 'userName',
);
IsmCall.i.startCall(
  meetingId: meetingId,
  call: call,
  userInfo: userInfo,
);

```

13. Disconnects the current call.

```dart
IsmCall.i.disconnectCall();

```

14. Updates the call configuration with the provided `IsmCallConfig`.

- `config` - New configuration for the call.

- `Future<bool>` - Indicates whether the configuration was updated successfully.

```dart
final config = IsmCallConfig(
  // configuration settings
);
final updated = await IsmCall.i.updateConfig(config);
if (updated) {
  print('Configuration updated successfully');
} else {
  print('Failed to update configuration');
}

```

15. Listens for changes in connectivity and calls the provided onChange callback with a boolean indicating connectivity status.

- `onChange` - Callback function that takes a boolean indicating connectivity status.

```dart
IsmCall.i.onConnectivityChange((connected) {
  if (connected) {
    print('Device is connected');
  } else {
    print('Device is not connected');
  }
});

```

16. Releases resources used by the `IsmCall` instance, such as closing open connections.

```dart
await IsmCall.i.dispose();

```
