class Company {
  final String id;
  final String name;
  final String logoUrl;
  final String area;
  final String city;
  final String state;
  final String description;
  final String? website;
  final String size;
  final String email;

  const Company({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.area,
    required this.city,
    required this.state,
    required this.description,
    this.website,
    required this.size,
    required this.email,
  });

  String get location => '$city, $state';
}
