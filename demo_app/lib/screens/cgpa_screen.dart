import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/custom_card.dart';

class CGPAScreen extends StatefulWidget {
  const CGPAScreen({super.key});

  @override
  State<CGPAScreen> createState() => _CGPAScreenState();
}

class _CGPAScreenState extends State<CGPAScreen> {
  final List<Student> students = [];

  final nameController = TextEditingController();
  final percentageController = TextEditingController();

  Student calculateStudent(String name, double percentage) {
    double gpa;
    String grade;

    if (percentage >= 85) {
      gpa = 4.0;
      grade = "A+";
    } else if (percentage >= 70) {
      gpa = 3.0;
      grade = "B";
    } else if (percentage >= 50) {
      gpa = 2.0;
      grade = "C";
    } else {
      gpa = 0.0;
      grade = "F";
    }

    return Student(name, percentage, gpa, grade);
  }

  void addStudent() {
    String name = nameController.text;
    double percentage = double.tryParse(percentageController.text) ?? 0;

    setState(() {
      students.add(calculateStudent(name, percentage));
    });

    nameController.clear();
    percentageController.clear();
  }

  double getAverage() {
    if (students.isEmpty) return 0.0;
    return students.fold<double>(0.0, (sum, s) => sum + s.gpa) /
        students.length;
  }

  @override
  void dispose() {
    nameController.dispose();
    percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CGPA System")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: percentageController,
              decoration: const InputDecoration(labelText: "Percentage"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: addStudent, child: const Text("Add Student")),

            const SizedBox(height: 10),

            Text("Average GPA: ${getAverage().toStringAsFixed(2)}"),

            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (_, i) {
                  var s = students[i];
                  return CustomCard(
                    child: ListTile(
                      title: Text(s.name),
                      subtitle: Text("GPA: ${s.gpa} | Grade: ${s.grade}"),
                      trailing: Text("${s.percentage}%"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
