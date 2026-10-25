import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class AgendaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream en tiempo real de los eventos en Firestore
  Stream<List<EventModel>> getEvents() {
    return _firestore
        .collection('events')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Método para agregar un evento nuevo a Firestore
  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime date,
    required String creatorEmail,
  }) async {
    try {
      await _firestore.collection('events').add({
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'creatorEmail': creatorEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error al agregar el evento: $e');
    }
  }

  // Método para eliminar un evento
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      debugPrint('Error al eliminar el evento: $e');
    }
  }
}