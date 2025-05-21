class Province {
  final int? id;
  final String name;
  final String? nameChinese;
  final String? nameThailand;
  final String? nameMyanmar;

  Province({
    required this.id,
    required this.name,
    required this.nameChinese,
    required this.nameThailand,
    required this.nameMyanmar,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
      nameChinese: json['name_chinese'],
      nameThailand: json['name_thailand'],
      nameMyanmar: json['name_myanmar'],
    );
  }
}
