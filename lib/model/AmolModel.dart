class AmolModel {
  int id;
  String name;
  String arabic;
  String bangla;
  String description;
  int target;
  int count;
  int totalCount;
  bool defaultAmol;
  bool favourite;

  AmolModel({
    required this.id,
    required this.name,
    required this.arabic,
    required this.bangla,
    required this.description,
    required this.target,
    required this.count,
    required this.totalCount,
    required this.defaultAmol,
    required this.favourite,
  });

  factory AmolModel.fromJson(Map<String, dynamic> json) {
    return AmolModel(
      id: json['id'],
      name: json['name'],
      arabic: json['arabic'],
      bangla: json['bangla'],
      description: json['description'],
      target: json['target'],
      count: json['count'],
      totalCount: json['totalCount'],
      defaultAmol: json['defaultAmol'],
      favourite: json['favourite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arabic': arabic,
      'bangla': bangla,
      'description': description,
      'target': target,
      'count': count,
      'totalCount': totalCount,
      'defaultAmol': defaultAmol,
      'favourite': favourite,
    };
  }
}
