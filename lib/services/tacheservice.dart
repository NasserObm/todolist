import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/models/tache.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('taches');

  // Ajouter une tâche avec ID auto-généré
  Future<void> addTask(String title, String description) async {
    // Ajoute une nouvelle tâche dans Firestore avec un ID auto-généré
    await _taskCollection.add({
      'title': title,
      'description': description,
      'isCompleted': false,
    });
  }

  // Mettre à jour une tâche (modification de titre et de description)
  Future<void> updateTask(String id, String title, String description) async {
    // Mets à jour le titre et la description d'une tâche donnée
    await _taskCollection.doc(id).update({
      'title': title,
      'description': description,
    });
  }

  // Supprimer une tâche
  Future<void> deleteTask(String id) async {
    // Supprime la tâche avec l'ID correspondant
    await _taskCollection.doc(id).delete();
  }

  // Mettre à jour le statut de complétion d'une tâche
  Future<void> toggleTaskCompletion(String id, bool newValue) async {
    // Modifie le statut de complétion de la tâche avec l'ID donné
    await _taskCollection.doc(id).update({'isCompleted': newValue});
  }

  // Récupérer toutes les tâches en temps réel
  Stream<List<Task>> getTasks() {
    return _taskCollection.snapshots().map((snapshot) {
      // Pour chaque document, on crée un objet Task avec son ID
      return snapshot.docs.map((doc) {
        return Task.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
