class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String creatorEmail;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.creatorEmail,
  });

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'creatorEmail': creatorEmail,
    };
  }

  // Crear un EventModel desde un documento de Firestore
  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      creatorEmail: map['creatorEmail'] ?? '',
    );
  }
}