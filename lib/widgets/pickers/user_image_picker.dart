import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;


  Future<File?> _pickImage() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(image!.path);
    });

    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: _pickedImage == null ? Text('U', style: TextStyle(color: Colors.white, fontSize: 32),) : null ,
          backgroundColor: Colors.grey,
          radius: 40,
          backgroundImage: _pickedImage != null ?  FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
