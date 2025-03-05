import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalNotificationController {
  static const String _appId = "c5cf0f85-3910-41ce-9fd8-79d0ff3945ef";

  // 콜백 함수 타입 정의
  Function(OSNotification)? onNotificationReceived;

  Future<void> initialize({
    Function(OSNotification)? onNotificationReceived,
  }) async {
    this.onNotificationReceived = onNotificationReceived;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(_appId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);

    // 알림 수신 리스너 설정
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      if (onNotificationReceived != null) {
        onNotificationReceived(event.notification);
      }

      // 기본 표시 옵션 (필요에 따라 조정)
      event.preventDefault();
      event.notification.display();
    });
  }

  // 알림 권한 요청
  Future<void> promptPermission() async {
    await OneSignal.Notifications.requestPermission(true);
  }

  // 테스트 알림 보내기 (REST API 사용 - 실제 앱에서는 서버 측에서 처리해야 함)
  void sendTestNotification() {
    // 일반적으로 서버에서 처리되어야 하지만 테스트 목적으로 표시
    OneSignal.InAppMessages.addClickListener((event) {
      print('In-app message clicked: ${event.result}');
    });
  }
}
