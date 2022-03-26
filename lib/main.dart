import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/screens/homepage.dart';
import 'package:notes_app/theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


import 'model/model.dart';

const notesBox = 'boxNotes';
const tagsBox = 'boxTags';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(TagsAdapter());
  await Hive.openBox<Notes>(notesBox);
  await Hive.openBox<Tags>(tagsBox);
  AwesomeNotifications().initialize(null, [NotificationChannel(
      channelKey: 'reminder',
      channelName: 'Reminder Notification',
      channelDescription: 'Notifications'),]
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}

