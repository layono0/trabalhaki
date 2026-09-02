import 'company.dart';

enum JobModality { remote, hybrid, onsite }
enum ContractType { clt, pj, internship, apprentice, temporary }
enum ExperienceLevel { internship, junior, mid, senior, specialist }
enum JobStatus { active, paused, closed }

extension JobModalityExt on JobModality {
  String get label {
    switch (this) {
      case JobModality.remote: return 'Remoto';
      case JobModality.hybrid: return 'Híbrido';
      case JobModality.onsite: return 'Presencial';
    }
  }

  String get emoji => switch (this) {
    JobModality.remote => '🏠',
    JobModality.hybrid => '🏢',
    JobModality.onsite => '📍',
  };
}

extension ContractTypeExt on ContractType {
  String get label {
    switch (this) {
      case ContractType.clt: return 'CLT';
      case ContractType.pj: return 'PJ';
      case ContractType.internship: return 'Estágio';
      case ContractType.apprentice: return 'Jovem Aprendiz';
      case ContractType.temporary: return 'Temporário';
    }
  }
}

extension ExperienceLevelExt on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.internship: return 'Estágio';
      case ExperienceLevel.junior: return 'Júnior';
      case ExperienceLevel.mid: return 'Pleno';
      case ExperienceLevel.senior: return 'Sênior';
      case ExperienceLevel.specialist: return 'Especialista';
    }
  }
}

class Job {
  final String id;
  final String title;
  final Company company;
  final String city;
  final String state;
  final JobModality modality;
  final double? salaryMin;
  final double? salaryMax;
  final ContractType contractType;
  final ExperienceLevel level;
  final String experienceRequired;
  final List<String> benefits;
  final DateTime publishedAt;
  final String shortDescription;
  final String fullDescription;
  final List<String> requirements;
  final List<String> differentials;
  final String workSchedule;
  final String area;
  final JobStatus status;
  final int views;
  final int candidates;
  final int matches;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.city,
    required this.state,
    required this.modality,
    this.salaryMin,
    this.salaryMax,
    required this.contractType,
    required this.level,
    required this.experienceRequired,
    required this.benefits,
    required this.publishedAt,
    required this.shortDescription,
    required this.fullDescription,
    required this.requirements,
    required this.differentials,
    required this.workSchedule,
    required this.area,
    this.status = JobStatus.active,
    this.views = 0,
    this.candidates = 0,
    this.matches = 0,
  });

  String get location => '$city, $state';

  String get salaryRange {
    if (salaryMin == null && salaryMax == null) return 'A combinar';
    if (salaryMin != null && salaryMax != null) {
      return 'R\$ ${_formatSalary(salaryMin!)} - R\$ ${_formatSalary(salaryMax!)}';
    }
    if (salaryMin != null) return 'A partir de R\$ ${_formatSalary(salaryMin!)}';
    return 'Até R\$ ${_formatSalary(salaryMax!)}';
  }

  String _formatSalary(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.', ',')}k';
    }
    return value.toStringAsFixed(0);
  }
}
