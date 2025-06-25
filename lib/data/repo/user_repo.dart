import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeshare/data/user/app_user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> createUserIfNeeded() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = _users.doc(user.uid);
    if (!(await doc.get()).exists) {
      await doc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? user.email!.split('@')[0],
        'joinedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<AppUser?> getUserById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson(doc.data()!);
  }

  Future<AppUser?> findUserByEmail(String email) async {
    final query = await _users.where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) return null;
    return AppUser.fromJson(query.docs.first.data());
  }

  Future<List<AppUser>> getFriendsOfUser(String uid) async {
    final user = await getUserById(uid);
    if (user == null || user.friends.isEmpty) return [];

    final friendsDocs = await Future.wait(
      user.friends.map((friendId) => _users.doc(friendId).get()),
    );

    return friendsDocs
        .where((doc) => doc.exists)
        .map((doc) => AppUser.fromJson(doc.data()!))
        .toList();
  }

  Future<void> addFriend(String targetUid) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    final userRef = _users.doc(currentUid);
    await userRef.update({
      'friends': FieldValue.arrayUnion([targetUid]),
    });
  }

  Future<void> removeFriend(String targetUid) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    final userRef = _users.doc(currentUid);
    await userRef.update({
      'friends': FieldValue.arrayRemove([targetUid]),
    });
  }
}
