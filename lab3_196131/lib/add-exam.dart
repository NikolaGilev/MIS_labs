
import 'package:flutter/material.dart';

import 'exam-model.dart';

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
