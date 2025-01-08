import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/services/firebase_services/admin/admin_services.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  // Fetch all users from Firestore
  Stream<QuerySnapshot> _fetchUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  // Get the current logged-in user ID
  String? _currentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _currentUserId();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Manage Users',
          style:
              TextStyle(color: Color(0xFF41BEA6), fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF41BEA6)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final name = user['name'];
              final email = user['email'];
              final phone = user['phone'] ?? 'Not available';
              final profilePic = user['profile_pic'] ?? '';
              final isDisabled = user['disabled'] ?? false;
              final role = user['role'] ?? 'No role';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: UserCard(
                  userId: userId,
                  name: name,
                  email: email,
                  phone: phone,
                  profilePic: profilePic,
                  isDisabled: isDisabled,
                  role: role,
                  index: index + 1,
                  isCurrentUser: userId == currentUserId,
                  onToggleDisable: () =>
                      AdminServices().disableUser(userId, isDisabled),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String profilePic;
  final bool isDisabled;
  final String role;
  final VoidCallback onToggleDisable;
  final int index;
  final bool isCurrentUser;

  const UserCard({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.isDisabled,
    required this.index,
    required this.role,
    required this.onToggleDisable,
    required this.isCurrentUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          color: AppColors.white,
          shadowColor: Colors.black.withOpacity(0.9),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profilePic),
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: profilePic.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF41BEA6)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(email, style: const TextStyle(color: Colors.black)),
                    Text(phone, style: const TextStyle(color: Colors.black)),
                    const SizedBox(height: 4),
                    Text(
                      'Role: $role',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (!isCurrentUser)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onToggleDisable,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDisabled
                            ? const Color(0xFF92D7E7)
                            : const Color(0xFF00BF6D),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                      ),
                      child: Text(
                        isDisabled ? 'Enable Account' : 'Disable Account',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                            "Sorry :-(", "Current User can be altered");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                      ),
                      child: const Text(
                        'Current User',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          child: Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.shade700,
            ),
            child: Center(
                child: Text(
              "#${index.toString()}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
