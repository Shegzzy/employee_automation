class Employee {
  final int? id;
  final String firstName;
  final String lastName;
  final String designation;
  final String currentSalary;
  final String status;
  final int level;
  final double productivityScore;

  Employee({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.level,
    required this.productivityScore,
    required this.status,
    required this.currentSalary
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    designation: json['designation'],
    level: json['level'],
    productivityScore: json['productivity_score'],
    status: json['employment_status'],
    currentSalary: json['current_salary'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'designation': designation,
    'level': level,
    'score': productivityScore,
    'current_salary': currentSalary,
    'productivity_score': productivityScore,
  };

  Map<String, dynamic> toMap() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'designation': designation,
    'level': level,
    'score': productivityScore,
    'current_salary': currentSalary,
    'productivity_score': productivityScore,
  };

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
    id: map['id'],
    firstName: map['first_name'],
    lastName: map['last_name'],
    designation: map['designation'],
    level: map['level'],
    productivityScore: map['productivity_score'],
    status: map['employment_status'],
    currentSalary: map['current_salary'],
  );
}
