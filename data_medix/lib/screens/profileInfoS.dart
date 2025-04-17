import 'package:data_medix/providers/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileInfoScreen extends ConsumerStatefulWidget {
  const ProfileInfoScreen({Key? key}) : super(key: key);

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends ConsumerState<ProfileInfoScreen> {
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();
  
  // Example user data - replace with your actual user model

  @override
  Widget build(BuildContext context) {
    ref.watch(fetchF).getUserData();
     final userData =  ref.watch(fetchF).userData;

    return SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Information'),
          actions: [
        IconButton(
          icon: Icon(_isEditMode ? Icons.save : Icons.edit),
          onPressed: () {
            setState(() {
          if (_isEditMode) {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _isEditMode = false;
            }
          } else {
            _isEditMode = true;
          }
            });
          },
        ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Center(
            child: Stack(
              children: [
            CircleAvatar(
              radius: 40, // Reduced size
              //backgroundImage: AssetImage(''),
            ),
            if (_isEditMode)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 15, // Reduced size
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.camera_alt_rounded, size: 15),
                onPressed: () {
                  // Handle image upload
                },
              ),
                ),
              ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 600
              ? Row(
              children: [
                Expanded(
                  child: _buildProfileField('First Name', 'First Name', userData),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildProfileField('Last Name', 'Last Name', userData),
                ),
              ],
                )
              : Column(
              children: [
                _buildProfileField('First Name', 'First Name', userData),
                const SizedBox(height: 8),
                _buildProfileField('Last Name', 'Last Name', userData),
              ],
                );
            },
          ),
          _buildProfileField('Email', 'Email', userData),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: userData!["Profession"],
              isExpanded: true,
              decoration: InputDecoration(
            labelText: 'Profession',
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(),
            filled: true,
            enabled: _isEditMode,
              ),
              items: <String>[
            'Doctor',
            'Nurse',
            'Pharmacist',
            'Lab Technician',
            'Radiologist',
            'Physiotherapist',
            'Other Healthcare Professional',
              ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.black)),
            );
              }).toList(),
              onChanged: _isEditMode
              ? (String? newValue) {
              setState(() {
                ref.read(fetchF).updateUserdata('Profession', newValue ?? userData["profession"]);
              });
                }
              : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: userData['Specialty'],
              isExpanded: true,
              decoration: InputDecoration(
            labelText: 'Specialty',
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(),
            filled: true,
            enabled: _isEditMode,
              ),
              items: <String>[
            'General Practice',
            'Cardiology',
            'Pediatrics',
            'Neurology',
            'Orthopedics',
            'Dermatology',
            'Oncology',
              ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.black)),
            );
              }).toList(),
              onChanged: _isEditMode
              ? (String? newValue) {
              setState(() {
                ref.read(fetchF).updateUserdata('Specialty', newValue ?? userData["Specialty"]);
              });
                }
              : null,
            ),
          ),
          const SizedBox(height: 24),
          if (!_isEditMode)
            Center(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: _showDeleteConfirmation,
            child: const Text('Delete Account'),
              ),
            ),
            ],
          ),
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String field ,final userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: userData[field],
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: OutlineInputBorder(),
          prefixStyle: TextStyle(
            color: Colors.black,
          ),
          suffixIcon: _isEditMode
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      userData[field] = '';
                    });
                  },
                )
              : null,
          suffixText: _isEditMode ? 'Edit' : null,
          suffixStyle: TextStyle(
            color: Colors.black,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          enabled: _isEditMode,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
        onSaved: (value) {
          if (value != null) {
            ref.read(fetchF).updateUserdata(field, value);
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete account logic here
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}