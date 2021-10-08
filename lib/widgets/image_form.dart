import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ImageForm extends StatefulWidget {
  final Function(File image) onImagePicked;
  const ImageForm({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: Text(l10n?.addImageButton ?? 'Add Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final imageXFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (imageXFile != null) {
      setState(() => _imageFile = File(imageXFile.path));
      widget.onImagePicked(_imageFile!);
    }
  }
}
