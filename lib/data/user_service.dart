import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('users');

  Future<void> _ensureUsersPathExists() async {
    DatabaseEvent event = await _database.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value == null) {
      await _database.set({});
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    await _ensureUsersPathExists();

    String userId = data['userId'];
    await _database.child(userId).update(data);
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    await _ensureUsersPathExists();

    DatabaseEvent event = await _database.child(userId).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      return {};
    }
  }
}
