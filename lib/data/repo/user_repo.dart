import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CalendarRepository _calendarRepo;

  UserRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    required CalendarRepository calendarRepo,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _calendarRepo = calendarRepo;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _calendars =>
      _firestore.collection('calendars');

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
    }
  }

  /// Retrieve selected AppUser from the firestore.
  /// If no uid is provided, it will default to the current user.
  Future<AppUser?> getUserById([String uid = '']) async {
    if (uid.isEmpty && currentUserId != null) uid = currentUserId!;
    if (uid.isEmpty) return null;
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson(doc.data()!);
  }

  Future<List<AppUser>> searchUsersByEmail(String email) async {
    if (email.isEmpty || email.length < 5) {
      return [];
    }
    final query = await _users
        .where('email', isGreaterThanOrEqualTo: email)
        .where('email', isLessThanOrEqualTo: '$email\uf8ff')
        .limit(10)
        .get();
    if (query.docs.isEmpty) return [];
    return query.docs
        .map((doc) => AppUser.fromJson(doc.data()).copyWith(uid: doc.id))
        .toList();
  }

  /// Get friends of a user. Defaults to current user.
  /// Uses batched whereIn queries instead of N+1 individual queries.
  Future<List<AppUser>> getFriendsOfUser([String uid = '']) async {
    if (uid.isEmpty && currentUserId != null) uid = currentUserId!;
    if (uid.isEmpty) return [];
    final user = await getUserById(uid);
    if (user == null || user.friends.isEmpty) {
      return [];
    }

    final friendIds = user.friends;
    final friends = <AppUser>[];

    // Batch in groups of 30 (Firestore whereIn limit)
    for (var i = 0; i < friendIds.length; i += 30) {
      final batch = friendIds.skip(i).take(30).toList();
      final snapshot =
          await _users.where(FieldPath.documentId, whereIn: batch).get();
      friends.addAll(
        snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => AppUser.fromJson(doc.data())),
      );
    }

    return friends;
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

  /// Update the display name for the current user
  Future<void> updateDisplayName(String newDisplayName) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    final userRef = _users.doc(currentUid);
    await userRef.update({'displayName': newDisplayName});
  }

  /// Delete the current user's account and all associated data.
  /// This performs cascade deletion:
  /// 1. Delete all calendars owned by the user (and their events)
  /// 2. Remove user from all sharedWith arrays
  /// 3. Remove user from all friends lists
  /// 4. Delete user document
  /// 5. Delete Firebase Auth account
  Future<void> deleteUserAccount() async {
    final currentUid = currentUserId;
    if (currentUid == null) {
      throw Exception('You must be logged in to delete your account.');
    }

    // 1. Get all calendars owned by user and delete them (cascade deletes events)
    final ownedCalendars = await _calendars
        .where('owner', isEqualTo: currentUid)
        .get();

    for (final doc in ownedCalendars.docs) {
      await _calendarRepo.deleteCalendar(doc.id);
    }

    // 2. Remove user from sharedWith arrays of other calendars
    final sharedCalendars = await _calendars
        .where('sharedWith', arrayContains: currentUid)
        .get();

    if (sharedCalendars.docs.isNotEmpty) {
      final sharedBatch = _firestore.batch();
      for (final doc in sharedCalendars.docs) {
        sharedBatch.update(doc.reference, {
          'sharedWith': FieldValue.arrayRemove([currentUid])
        });
      }
      await sharedBatch.commit();
    }

    // 3. Remove user from other users' friends lists
    final usersWithFriend = await _users
        .where('friends', arrayContains: currentUid)
        .get();

    if (usersWithFriend.docs.isNotEmpty) {
      final friendsBatch = _firestore.batch();
      for (final doc in usersWithFriend.docs) {
        friendsBatch.update(doc.reference, {
          'friends': FieldValue.arrayRemove([currentUid])
        });
      }
      await friendsBatch.commit();
    }

    // 4. Delete user document
    await _users.doc(currentUid).delete();

    // 5. Delete Firebase Auth account
    await _auth.currentUser?.delete();
  }
}
