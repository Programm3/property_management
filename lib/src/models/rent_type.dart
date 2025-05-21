class RentType {
  final int id;
  final String name;
  final String? nameChinese;
  final String? nameThailand;
  final String? nameMyanmar;

  RentType({
    required this.id,
    required this.name,
    this.nameChinese,
    this.nameThailand,
    this.nameMyanmar,
  });

  factory RentType.fromJson(Map<String, dynamic> json) {
    return RentType(
      id: json['id'],
      name: json['name'],
      nameChinese: json['name_chinese'],
      nameThailand: json['name_thailand'],
      nameMyanmar: json['name_myanmar'],
    );
  }
}
