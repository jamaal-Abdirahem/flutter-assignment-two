// import 'package:dart_application_1/dart_application_1.dart' as dart_application_1;

// Function to convert a letter grade to its corresponding Grade Point
double getGradePoint(String grade) {
  // Use a switch statement for grade calculation
  switch (grade.toUpperCase()) {
    case 'A':
      return 4.0;
    case 'B':
      return 3.0;
    case 'C':
      return 2.0;
    case 'D':
      return 1.0;
    case 'F':
      return 0.0;
    default:
      // Handle invalid grades
      print("Warning: Grade '$grade' is invalid. Assuming 0.0.");
      return 0.0;
  }
}

// Function to calculate the CGPA
double calculateCGPA(Map<String, Map<String, dynamic>> courses) {
  // Variable declarations and assignments
  double totalQualityPoints = 0.0;
  int totalCreditHours = 0;

  // Iterate through the courses
  for (var course in courses.entries) {
    String courseName = course.key;
    int creditHours = course.value['credits'];
    String grade = course.value['grade'];

    // Calculate Grade Point
    double gradePoint = getGradePoint(grade);

    // Calculate Quality Points (Credit Hours * Grade Point)
    double qualityPoints = creditHours * gradePoint;

    // Update total points and hours
    totalQualityPoints += qualityPoints;
    totalCreditHours += creditHours;
  }

  // Calculate CGPA (if total credit hours > 0)
  if (totalCreditHours == 0) {
    return 0.0;
  }

  // Return the calculated CGPA
  return totalQualityPoints / totalCreditHours;
}

void main() {
  // Sample student data (variable declaration and assignment)
  // This replaces the missing table from the assignment
  var studentCourses = {
    "Mobile Application": {"credits": 3, "grade": "A"},
    "Data Structures": {"credits": 4, "grade": "B"},
    "Calculus": {"credits": 3, "grade": "C"},
    "English Literature": {"credits": 2, "grade": "A"},
  };

  print("Student CGPA Calculator");
  print("-----------------------");
  print("Course Data Used:");
  studentCourses.forEach((name, data) {
    print("- $name: ${data['credits']} credits, Grade: ${data['grade']}");
  });
  print("-----------------------");

  double cgpa = calculateCGPA(studentCourses);

  // Conditional check to display the CGPA result
  if (cgpa > 0) {
    print("The student's CGPA is: ${cgpa.toStringAsFixed(2)}");
  } else {
    print("Could not calculate CGPA. Total credit hours are zero.");
  }
}
