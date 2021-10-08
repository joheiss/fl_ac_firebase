import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/auth_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(l10n?.authPageTitle ?? 'Logon'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AuthForm(
              onSubmit: _submitAuth,
              isLoading: _isLoading,
            ),
          ),
        ),
      ),
    );
  }

  void _submitAuth(String email, String password, String? username, File? imageFile, [bool? isLogin = true]) async {
    print('[DEBUG] => submit to auth with: $email, $password, $username');
    setState(() => _isLoading = true);
    UserCredential? credential;
    try {
      final auth = FirebaseAuth.instance;
      if (isLogin!) {
        credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        var imageUrl = '';
        credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        // image upload to firebase storage
        if (imageFile != null) {
          final ref = FirebaseStorage.instance.ref().child('user_images').child('${credential.user?.uid}.jpg');
          await ref.putFile(imageFile).whenComplete(() => null);
          imageUrl = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
          'username': username,
          'email': email,
          'imageUrl': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      print('[DEBUG] => auth error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } on PlatformException catch (e) {
      print('[DEBUG] => platform error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (e) {
      print('[DEBUG] => other error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
