import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeshare/data/models/user/app_user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  String? get currentUserId => _auth.currentUser?.uid;

  Future<AppUser?> get currentUser async {
    if (currentUserId == null) return null;
    return await getUserById(currentUserId!);
  }

  Future<void> signInOrRegister() async {
    final user = _auth.currentUser;

    if (user == null) throw (FirebaseAuthException);

    final doc = _users.doc(user.uid);

    // register
    if (!(await doc.get()).exists) {
      await doc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? user.email!.split('@')[0],
        'joinedAt': FieldValue.serverTimestamp(),
      });
      print('User ${user.email} created!');
    }
    // sign in
    else {
      print('Username ${user.email} already exists!');
    }
  }

  /// retrieve selected AppUser from the firestore.
  ///  if no uid is provided, it will default to the current user.
  Future<AppUser?> getUserById([String uid = '']) async {
    if (uid.isEmpty && currentUserId != null) uid = currentUserId!;
    if (uid.isEmpty) return null;
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    print(' -getUserBy id found $uid');
    return AppUser.fromJson(doc.data()!);
  }

  Future<List<AppUser>> searchUsersByEmail(String email) async {
    if (email.isEmpty || email.length < 5) {
      print('insufficient query: $email');
      return [];
    }
    final query =
        await _users
            .where('email', isGreaterThanOrEqualTo: email)
            .where('email', isLessThanOrEqualTo: '$email\uf8ff')
            .limit(10)
            .get();
    if (query.docs.isEmpty) return [];
    return query.docs
        .map((doc) => AppUser.fromJson(doc.data()).copyWith(uid: doc.id))
        .toList();
  }

  Future<List<AppUser>> getFriendsOfUser([String uid = '']) async {
    if (uid.isEmpty && currentUserId != null) uid = currentUserId!;
    if (uid.isEmpty) return [];
    final user = await getUserById(uid);
    if (user == null || user.friends.isEmpty) {
      print('user == null || user.friends.isEmpty');
      return [];
    }

    final friendsDocs = await Future.wait(
      user.friends.map((friendId) => _users.doc(friendId).get()),
    );

    print('attempting return from found friend docs');
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
