import 'dart:math';
import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'add-exam.dart';
import 'auth-layer.dart';
import 'auth-service.dart';
import 'exam-model.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  tzdata.initializeTimeZones();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
        controller: EventController(),
        child:  MaterialApp(
        title: 'Termini za kolokvium i ispiti',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: AuthenticationWrapper(),
      )
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User? user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Exam> exams;
  bool showCalendarView = true;
  late DateTime _selectedDay;
  late EventController _calendarController;

  @override
  void initState() {
    super.initState();
    exams = [Exam(subject: 'Math 1', dateTime: DateTime.now().add(const Duration(days: 3))),Exam(subject: 'Math 2', dateTime: DateTime.now().add(const Duration(days: 2)))];
    _selectedDay = DateTime.now();
    _calendarController = EventController();
  }

  Future<void> _scheduleNotification(Exam item) async {
    if((item.dateTime.difference(DateTime.now())).inDays<= 1){
      return;
    }
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      ongoing: true,

      styleInformation: BigTextStyleInformation(''),
    );
    final notificationId = Random().nextInt(1000000000);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);


    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Reminder: ${item.subject}',
        'You have an exam tomorrow',
        tz.TZDateTime.from(item.dateTime.add(const Duration(days: 1)), tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime
      );
  }

  void _addNewItemToList(Exam item) async{
    setState(() {
      exams.add(item);
    });
    await _scheduleNotification(item);
    print(item.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showCalendarView ? MonthView(
        controller: _calendarController,
        cellBuilder: (date, events, isToday, isInMonth) {
          List<Exam> examsForDate = _getExamsForDate(date);
          return _buildCell(date, examsForDate);
        },
        onCellTap: (events, date) {
          setState(() {
            _selectedDay = date;
          });
        },
        minMonth: DateTime(1990),
        maxMonth: DateTime(2050),
        cellAspectRatio: 1,

      )
          : ExamList(exams: exams),
      appBar: AppBar(
        title: const Text('Manage Kolokviumi and Ispiti'),
        leading: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.green,
            size: 40.0,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddExamDialog(onExamAdded: (Exam newExam) {
                  setState(() {
                    _addNewItemToList(newExam);
                  });
                });
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              showCalendarView ? Icons.list : Icons.calendar_today,
              color: Colors.blue,
              size: 30.0,
            ),
            onPressed: () {
              setState(() {
                showCalendarView = !showCalendarView;
              });
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 30.0,
              ),
              onPressed: () {
                AuthService().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(DateTime date, List<Exam> exams) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: _isSelectedDate(date)
            ? Colors.yellow
            : exams.isEmpty ? Colors.white: Colors.greenAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: _isSelectedDate(date)
                  ? Colors.red
                  :  Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          if (exams.isNotEmpty)
            ...exams.map(
                  (exam) => Text(
                'Subj: ${exam.subject}\nTime: ${exam.dateTime.hour} : ${exam.dateTime.minute}',
                style: TextStyle(
                  color: _isSelectedDate(date)
                      ? Colors.red
                      :  Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isSelectedDate(DateTime date) {
    return _selectedDay.year == date.year &&
        _selectedDay.month == date.month &&
        _selectedDay.day == date.day;
  }

  bool _isExamDate(DateTime examDate,DateTime date) {
    return  examDate.year == date.year &&
        examDate.month == date.month &&
        examDate.day == date.day;
  }

  List<Exam> _getExamsForDate(DateTime date) {
    return exams.where((exam) => _isExamDate(exam.dateTime,date)).toList();
  }
}


