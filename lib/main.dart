import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/screens/addNotes.dart';
import 'package:notes_app/screens/homepage.dart';
import 'package:notes_app/theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


import 'model/model.dart';

const notesBox = 'boxNotes';
const tagsBox = 'boxTags';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DotEnv().load(fileName: '.env');
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
  Geofence.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}

