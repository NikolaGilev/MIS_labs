import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3_196131/registration-screen.dart';
import 'auth-service.dart';
import 'login_screen.dart';
import 'firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Termini za kolokvium i ispiti',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
            User? user = snapshot.data;
            return HomeScreen(user: user);
        }
        return AuthScreen();
      },
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Kolokvium/ispit picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text('Log in'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
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
  List<Exam> exams = [Exam(subject: 'Math 1', dateTime: DateTime.now())];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    exams.add(newExam);
                  });
                });
              },
            );
          },
        ),
        actions: [
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
      body: ExamList(exams: exams),
    );
  }
}

class AddExamDialog extends StatefulWidget {
  final Function(Exam) onExamAdded;

  AddExamDialog({required this.onExamAdded});

  @override
  _AddExamDialogState createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  TextEditingController subjectController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Exam'),
      content: Column(
        children: [
          TextField(
            controller: subjectController,
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Date and Time'),
            subtitle: Text('$selectedDateTime'),
            onTap: () => _selectDateTime(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (subjectController.text.isNotEmpty) {
              Exam newExam = Exam(
                subject: subjectController.text,
                dateTime: selectedDateTime,
              );
              widget.onExamAdded(newExam);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in the subject field.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class ExamList extends StatelessWidget {
  final List<Exam> exams;

  ExamList({required this.exams});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        return ExamCard(exam: exams[index]);
      },
    );
  }
}

class ExamCard extends StatelessWidget {
  final Exam exam;

  ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 20.0,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Date and Time: ${exam.dateTime}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Exam {
  final String subject;
  final DateTime dateTime;

  Exam({required this.subject, required this.dateTime});
}
