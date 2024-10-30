import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String text;
  final String? textExtra;
  final String type;
  final int index;

  Question({required this.text, this.textExtra, required this.type, required this.index});

  // Convert Firestore document to Question object
  factory Question.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Question(
      text: data?['text'] ?? '',
      textExtra: data?['textExtra'],
      type: data?['type'] ?? '',
      index: data?['index'] ?? 0,
    );
  }

  // Convert Question object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      "text": text,
      if (textExtra != null) "textExtra": textExtra,
      "type": type,
      "index": index,
    };
  }

  // Helper method to create Question from a plain Map
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] ?? '',
      textExtra: map['textExtra'],
      type: map['type'] ?? '',
      index: map['index'] ?? 0,
    );
  }
}

