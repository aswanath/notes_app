import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() {
  return DateTime.now().year +
      DateTime.now().month +
      DateTime.now().hour +
      DateTime.now().minute +
      DateTime.now().millisecond;
}

Future<void> createReminderNotification(
    DateTime notificationSchedule,{String? title,required String note}) async {
  print("created");
  await AwesomeNotifications().createNotification(
      content:
          NotificationContent(id: createUniqueId(), channelKey: 'reminder',
          title: title??'',
            body: note,
            notificationLayout: NotificationLayout.Default
          ),
  actionButtons: [NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done')],
    schedule: NotificationCalendar(repeats: false,
    year: notificationSchedule.year,
        month: notificationSchedule.month,
        day: notificationSchedule.day,
        hour: notificationSchedule.hour,
      minute: notificationSchedule.minute,
      second: 0,
      millisecond: 0
    )
  );
}
