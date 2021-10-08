import 'dart:io';

import 'package:ac_firebase/widgets/image_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String? username, File? imageFile, bool? isLogin) onSubmit;
  final bool isLoading;
  const AuthForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _username = '';
  var _password = '';
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isLogin)
            ImageForm(
              onImagePicked: _storeImage,
            ),
          TextFormField(
            key: const ValueKey('email'),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty || !val.contains('@')) return l10n?.errorInvalidEmailAddress;
              return null;
            },
            onSaved: (val) => _email = val?.trim() ?? '',
            decoration: InputDecoration(
              labelText: l10n?.emailAddressLabel ?? 'Email Address',
            ),
          ),
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('username'),
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
              enableSuggestions: false,
              validator: (val) {
                if (val == null || val.isEmpty) return l10n?.errorInvalidUsername;
                return null;
              },
              onSaved: (val) => _username = val?.trim() ?? '',
              decoration: InputDecoration(
                labelText: l10n?.userNameLabel ?? 'Username',
              ),
            ),
          TextFormField(
            key: const ValueKey('password'),
            obscureText: true,
            validator: (val) {
              if (val == null || val.length < 7) return l10n?.errorPasswordTooShort;
              return null;
            },
            onSaved: (val) => _password = val?.trim() ?? '',
            decoration: InputDecoration(
              labelText: l10n?.passwordLabel ?? 'Password',
            ),
          ),
          const SizedBox(height: 32),
          if (widget.isLoading) ...[
            const Center(child: CircularProgressIndicator.adaptive()),
          ] else ...[
            ElevatedButton(
              onPressed: _trySubmit,
              child: Text(_isLogin ? l10n?.loginButton ?? 'Login' : l10n?.signupButton ?? 'Register'),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? l10n?.signupButton ?? 'Register' : l10n?.loginButton ?? 'Login'),
            ),
          ]
        ],
      ),
    );
  }

  void _storeImage(File image) {
    _imageFile = image;
  }

  void _trySubmit() {
    final l10n = AppLocalizations.of(context);
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (!_isLogin && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.errorPickImage ?? 'Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState?.save();
    }
    // send auth request to firebase
    widget.onSubmit(_email, _password, _username, _imageFile, _isLogin);
  }
}
