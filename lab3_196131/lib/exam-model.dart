
import 'package:flutter/material.dart';

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
