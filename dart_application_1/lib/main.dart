import 'dart:io';

// ================= CALCULATOR FUNCTIONS =================
double add(double a, double b) => a + b;
double subtract(double a, double b) => a - b;
double multiply(double a, double b) => a * b;

double divide(double a, double b) {
  if (b == 0) {
    print("❌ Error: Cannot divide by zero");
    return 0;
  }
  return a / b;
}

void calculator() {
  print("\n==== CALCULATOR ====");

  stdout.write("Enter first number: ");
  double num1 = double.parse(stdin.readLineSync()!);

  stdout.write("Enter second number: ");
  double num2 = double.parse(stdin.readLineSync()!);

  stdout.write("Choose operation (+, -, *, /): ");
  String op = stdin.readLineSync()!;

  double result;

  if (op == '+') {
    result = add(num1, num2);
  } else if (op == '-') {
    result = subtract(num1, num2);
  } else if (op == '*') {
    result = multiply(num1, num2);
  } else if (op == '/') {
    result = divide(num1, num2);
  } else {
    print("❌ Invalid operation");
    return;
  }

  print("✅ Result: $result");
}

// ================= STUDENT CLASS =================
class Student {
  String name;
  double percentage;
  double gpa;
  String grade;

  Student(this.name, this.percentage, this.gpa, this.grade);
}

// ================= CGPA LOGIC =================
Student calculateStudent(String name, double percentage) {
  double gpa;
  String grade;

  if (percentage >= 85 && percentage <= 100) {
    gpa = 4.0;
    grade = "A+";
  } else if (percentage >= 80) {
    gpa = 3.7;
    grade = "A";
  } else if (percentage >= 75) {
    gpa = 3.3;
    grade = "B+";
  } else if (percentage >= 70) {
    gpa = 3.0;
    grade = "B";
  } else if (percentage >= 65) {
    gpa = 2.7;
    grade = "B-";
  } else if (percentage >= 60) {
    gpa = 2.3;
    grade = "C+";
  } else if (percentage >= 55) {
    gpa = 2.0;
    grade = "C";
  } else if (percentage >= 50) {
    gpa = 1.7;
    grade = "C-";
  } else if (percentage >= 45) {
    gpa = 1.3;
    grade = "D";
  } else if (percentage >= 40) {
    gpa = 1.0;
    grade = "D";
  } else {
    gpa = 0.0;
    grade = "E";
  }

  return Student(name, percentage, gpa, grade);
}

// ================= CGPA SYSTEM =================
void cgpaSystem() {
  List<Student> students = [];

  while (true) {
    print("\n==== CGPA SYSTEM ====");
    print("1. Add Student");
    print("2. View All Students");
    print("3. Show Average GPA");
    print("4. Back to Main Menu");

    stdout.write("Choose option: ");
    String choice = stdin.readLineSync()!;

    if (choice == '1') {
      stdout.write("Enter student name: ");
      String name = stdin.readLineSync()!;

      stdout.write("Enter percentage: ");
      double percentage = double.parse(stdin.readLineSync()!);

      Student s = calculateStudent(name, percentage);
      students.add(s);

      print("✅ Student Added Successfully!");
    } else if (choice == '2') {
      if (students.isEmpty) {
        print("⚠️ No students found.");
      } else {
        print("\n--- Student Records ---");
        for (var s in students) {
          print(
            "Name: ${s.name} | %: ${s.percentage} | GPA: ${s.gpa} | Grade: ${s.grade}",
          );
        }
      }
    } else if (choice == '3') {
      if (students.isEmpty) {
        print("⚠️ No data to calculate average.");
      } else {
        double total = 0;
        for (var s in students) {
          total += s.gpa;
        }
        double avg = total / students.length;
        print("📊 Average GPA: ${avg.toStringAsFixed(2)}");
      }
    } else if (choice == '4') {
      break;
    } else {
      print("❌ Invalid choice.");
    }
  }
}

// ================= MAIN MENU =================
void main() {
  while (true) {
    print("\n========== MAIN MENU ==========");
    print("1. Calculator");
    print("2. CGPA System");
    print("3. Exit");

    stdout.write("Choose an option: ");
    String choice = stdin.readLineSync()!;

    if (choice == '1') {
      calculator();
    } else if (choice == '2') {
      cgpaSystem();
    } else if (choice == '3') {
      print("👋 Goodbye!");
      break;
    } else {
      print("❌ Invalid choice.");
    }
  }
}
