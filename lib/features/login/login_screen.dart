
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/core/utils/add_constants.dart';
import 'dart:io';

import 'package:to_do_list/core/widgets/main_botton.dart';
import 'package:to_do_list/features/home/home_screen.dart';
import 'package:to_do_list/features/login/data/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> pickImageFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _imageFile = image);
    }
  }

  Future<void> pickImageFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = image);
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      final box = Hive.isBoxOpen(AddConstants.userBoxName)
          ? Hive.box<UserModel>(AddConstants.userBoxName)
          : await Hive.openBox<UserModel>(AddConstants.userBoxName);
      await box.put(AddConstants.currentUserKey, user);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: user.name),
        ),
      );
    } on HiveError catch (error) {
      debugPrint('Failed to save user data: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save your profile. Please try again.')),
      );
    }
  }
  
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainBotton(title: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          pickImageFromCamera();
                        },),
                        
        
                        20.verticalSpace,
        
                        MainBotton(title: 'Gallery',
                        onTap: () {
                          Navigator.pop(context); 
                          pickImageFromGallery();
                        },)
                      ],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _imageFile == null
                    ? null
                    : FileImage(File(_imageFile!.path)),
                child: _imageFile == null
                    ? Icon(
                        Icons.person,
                        size: 60.r,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
        
            Text(
              'Create Your Profile',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'Add your name and a profile picture',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),

            20.verticalSpace,

            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                // Handle name input
              },
            ),

            20.verticalSpace,

            MainBotton(
              title: 'Continue',
              onTap: (
        
              ) {saveUserData(UserModel(name: nameController.text, image: _imageFile?.path ?? ''));
              },
            ),
          ],
        ),
      ),
    );
  }
}