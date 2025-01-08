import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/pages/admin/services/doctor/edit_doctor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageDoctorScreen extends StatefulWidget {
  const ManageDoctorScreen({super.key});

  @override
  State<ManageDoctorScreen> createState() => _ManageDoctorScreenState();
}

class _ManageDoctorScreenState extends State<ManageDoctorScreen> {
  // Fetch all doctors from Firestore
  Stream<QuerySnapshot> _fetchDoctors() {
    return FirebaseFirestore.instance.collection('Doctors').snapshots();
  }

  // Function to delete a doctor
  Future<void> _deleteDoctor(String doctorId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorId)
          .delete();
      Get.snackbar('Deleted', 'Doctor deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error deleting doctor: $e');
    }
  }

  // Function to edit a doctor's details
  void _editDoctor(String doctorId) {
    // Navigate to edit doctor screen
    Get.to(EditDoctorScreen(doctorId: doctorId));
  }

  // Reusable widget to display doctor details
  Widget _buildDoctorDetail(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Manage Doctors',
          style: TextStyle(
            color: Color(0xFF41BEA6),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF41BEA6)),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _fetchDoctors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching doctors.'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No doctors found.'));
              }

              final doctors = snapshot.data!.docs;

              return Expanded(
                // Wrap ListView.builder with Expanded
                child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final doctorId = doctor.id;
                    final name = doctor['name'] ?? 'No name available';
                    final email = doctor['email'] ?? 'No email available';
                    final address = doctor['address'] ?? 'No address available';
                    final phone = doctor['phone'] ?? 'No phone available';
                    final specialization = doctor['specialization'] ??
                        'No specialization available';
                    final profilePic = doctor['profile_picture'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                // Doctor Image (Profile Pic)
                                ClipOval(
                                  child: profilePic.isNotEmpty
                                      ? Image.network(
                                          profilePic,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.grey,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                // Doctor Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF41BEA6),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildDoctorDetail(
                                          'Specialization:', specialization),
                                      _buildDoctorDetail('Phone:', phone),
                                      _buildDoctorDetail('Email:', email),
                                      _buildDoctorDetail('Address:', address),
                                    ],
                                  ),
                                ),
                                // Action Buttons
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () => _editDoctor(doctorId),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteDoctor(doctorId),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
