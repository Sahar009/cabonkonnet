import 'dart:convert';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String level;
  final String goals;
  final double fundsNeeded;
  final String impact;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.goals,
    required this.fundsNeeded,
    required this.impact,
  });

  // Factory method to create ProductModel from a map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['\$id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      level: map['level'] as String,
      goals: map['goals'] as String,
      fundsNeeded: (map['fundsNeeded'] as num).toDouble(),
      impact: map['impact'] as String,
    );
  }

  // Method to convert ProductModel to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'level': level,
      'goals': goals,
      'fundsNeeded': fundsNeeded,
      'impact': impact,
    };
  }

  // Factory method to create ProductModel from JSON
  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Method to convert ProductModel to JSON
  String toJson() => json.encode(toMap());

  // Copy method to create a new instance with optional overrides
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? level,
    String? goals,
    double? fundsNeeded,
    String? impact,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      goals: goals ?? this.goals,
      fundsNeeded: fundsNeeded ?? this.fundsNeeded,
      impact: impact ?? this.impact,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, level: $level, goals: $goals, fundsNeeded: $fundsNeeded, impact: $impact)';
  }
}
