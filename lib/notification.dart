import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() {
   int id = int.parse(DateTime.now().millisecondsSinceEpoch.toString().substring(0,10));
   return id;
}

Future<void> createReminderNotification(
    {String? title,required String note,required int key,DateTime? notificationSchedule}) async {
  await AwesomeNotifications().createNotification(
      content:
          NotificationContent(id: key, channelKey: 'reminder',
          title: title??'',
            body: note,
            notificationLayout: NotificationLayout.Default
          ),
  actionButtons: [NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done')],
    schedule: notificationSchedule!=null ?NotificationCalendar(repeats: false,
    year: notificationSchedule.year,
        month: notificationSchedule.month,
        day: notificationSchedule.day,
        hour: notificationSchedule.hour,
      minute: notificationSchedule.minute,
      second: 0,
      millisecond: 0
    ):null
  );
}
