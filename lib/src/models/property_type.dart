class PropertyType {
  final int? id;
  final String name;
  final String? nameChinese;
  final String? nameThailand;
  final String? nameMyanmar;

  PropertyType({
    required this.id,
    required this.name,
    required this.nameChinese,
    required this.nameThailand,
    required this.nameMyanmar,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json['id'],
      name: json['name'],
      nameChinese: json['name_chinese'],
      nameThailand: json['name_thailand'],
      nameMyanmar: json['name_myanmar'],
    );
  }
}
