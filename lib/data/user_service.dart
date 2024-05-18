import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

  Future<void> updateUserData(Map<String, dynamic> newData) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await _firestore.collection('users').doc(user.uid).update(newData);
  }

  Future<void> incrementUserLevel() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          transaction.set(userDoc, {'level': 1});
        } else {
          int newLevel = (snapshot.data() as Map<String, dynamic>)['level'] + 1;
          transaction.update(userDoc, {'level': newLevel});
        }
      });
    } catch (e) {
      print('Kullanıcı seviyesi artırılırken hata oluştu: $e');
    }
  }
}
