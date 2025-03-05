import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:push_notification_demo/one_signal_notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late OneSignalNotificationController _notificationController;
  String _notificationText = '-';

  @override
  void initState() {
    super.initState();

    _notificationController = OneSignalNotificationController();
    _notificationController.initialize(
      onNotificationReceived: _handleNotification,
    );
  }

  void _handleNotification(OSNotification notification) {
    setState(() {
      _notificationText = '알림 수신: ${notification.title} - ${notification.body}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Push Notification Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_notificationText),
            ElevatedButton(
              onPressed: _notificationController.promptPermission,
              child: Text('알림 권한 요청'),
            ),
            ElevatedButton(onPressed: () {}, child: Text('알림 테스트')),
          ],
        ),
      ),
    );
  }
}
