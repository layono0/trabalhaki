import 'job.dart';

class Candidate {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String desiredRole;
  final String area;
  final ExperienceLevel level;
  final String city;
  final String state;
  final List<JobModality> preferredModalities;
  final double? salaryExpectation;
  final List<ContractType> preferredContractTypes;
  final String bio;
  final List<WorkExperience> experiences;
  final List<Education> education;
  final List<String> skills;
  final int profileCompleteness;

  const Candidate({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.desiredRole,
    required this.area,
    required this.level,
    required this.city,
    required this.state,
    required this.preferredModalities,
    this.salaryExpectation,
    required this.preferredContractTypes,
    required this.bio,
    required this.experiences,
    required this.education,
    required this.skills,
    required this.profileCompleteness,
  });

  String get location => '$city, $state';
  String get initials => name.split(' ').take(2).map((n) => n[0]).join().toUpperCase();
}

class WorkExperience {
  final String role;
  final String company;
  final String period;
  final String description;

  const WorkExperience({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
  });
}

class Education {
  final String degree;
  final String institution;
  final String period;

  const Education({
    required this.degree,
    required this.institution,
    required this.period,
  });
}
