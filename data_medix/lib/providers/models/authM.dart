// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthF extends ChangeNotifier {
  String? username;
  Session? session;
  User? user;
  Map<String, dynamic>? userData;

  String? errorMessage;

  Future<void> signUp(String email1, String password1, String firstName,
      String lastName, String profession, String specialty) async {
        username = "$firstName $lastName";
    try {
    errorMessage = null;
      final AuthResponse res = await supabase.auth.signUp(
        email: email1,
        password: password1,
      );

      session = res.session;
      user = res.user;
      await supabase.from('Profiles').insert({
        'id': user?.id,
        'Email': email1,
        'First Name': firstName.replaceAll(" ", ""),
        'Last Name': lastName.replaceAll(" ", ""),
        'Profession': profession,
        'Specialty': specialty,
      });

    } catch (e) {
      errorMessage = e.toString();

    }
          notifyListeners();

  }

  Future<void> signin(String email1, String password1) async {
    try {
      errorMessage = null;
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email1,
        password: password1,
        
      );

    userData = await supabase.from("Profiles").select().eq("id", res.user!.id).single();
    username = "${userData!['First Name']} ${userData!['Last Name']}";
    session = res.session;
    user = res.user;
    } catch (e) {
      errorMessage = e.toString();
    }
        notifyListeners();
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    session = null;
    user = null;
    username = null;
    notifyListeners();
  }

  Future<String?> geterrorMessege() async {
   return  errorMessage;
}
}