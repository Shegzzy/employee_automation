class Employee {
  final int? id;
  final String firstName;
  final String lastName;
  final String designation;
  final String currentSalary;
  final int status;
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
    'employment_status': status,
    'current_salary': currentSalary,
    'productivity_score': productivityScore,
  };

  static Map<String, dynamic> sampleJson() => {
    "first_name": "",
    "last_name": "",
    "designation": "",
    "level": 0,
    "productivity_score": 0.0,
    "current_salary": "",
    "employment_status": 1,
  };

  Employee copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? designation,
    int? level,
    double? productivityScore,
    String? currentSalary,
    int? employmentStatus,
  }) {
    return Employee(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      designation: designation ?? this.designation,
      level: level ?? this.level,
      productivityScore: productivityScore ?? this.productivityScore,
      currentSalary: currentSalary ?? this.currentSalary,
      status: employmentStatus ?? status,
    );
  }
}
