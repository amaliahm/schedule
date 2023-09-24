import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:schedule/addTaskBar.dart';
import 'package:schedule/db_helper.dart';
import 'package:schedule/schedule.dart';
import 'firebase_options.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFFF4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

final FlutterLocalNotificationsPlugin notification =
    FlutterLocalNotificationsPlugin();

Future<void> showNotification() async {
  BigTextStyleInformation info = const BigTextStyleInformation(
    'body',
    htmlFormatBigText: true,
    contentTitle: 'title',
    htmlFormatContentTitle: true,
  );
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'try_1', // Replace with your own channel ID
    'channel_name', // Replace with your own channel name
    // 'channel_description', // Replace with your own channel description
    importance: Importance.high,
    priority: Priority.high,
    styleInformation: info,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound(
        'viber_message'), // Use the custom sound resource name here
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await notification.show(
    0, // Replace with a unique ID for each notification
    'title', // Replace with your notification title
    'body', // Replace with your notification body
    platformChannelSpecifics,
    payload:
        'New Notification', // You can pass additional data with the notification
  );
}

class themeService {
  final _box = GetStorage();
  final key = 'dark';
  _saveThemeToBox(bool dark) => _box.write(key, dark);
  bool _loadThemeFromBox() => _box.read(key) ?? false;
  ThemeMode get _theme =>
      _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DBHelper.initDb();
  await GetStorage.init();
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('my_icon');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await notification.initialize(
    initializationSettings,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // to remove hadak ta3 debug in my app
      title: 'schedule',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: darkGreyClr,
        brightness: Brightness.dark,
      ),
      themeMode: themeService()._theme,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SchedulePage(),
    );
  }
}
