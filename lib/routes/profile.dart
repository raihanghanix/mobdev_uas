// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification_app_demo/routes/login.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/utils/file_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import '../utils/custom_theme.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.userData,
    required this.updateUserData,
  });

  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) updateUserData;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _textFieldController = TextEditingController();
  String email = "";

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.userData['email'];
    email = widget.userData['email'];
  }

  void handleLogout() async {
    await FileController(context: context).deleteFile('user.json');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  void handleChangeEmail() async {
    final List<dynamic> user =
        await DBController(context: context).getUser(_textFieldController.text);
    if (_textFieldController.text.isEmpty) {
      CustomSnackbar.danger(context, "Email kosong!");
    } else if (user.isNotEmpty) {
      CustomSnackbar.danger(context, "Email sudah terdaftar!");
    } else {
      final query = await DBController(context: context).changeEmail(
        _textFieldController.text,
        widget.userData['id'],
      );
      if (query) {
        final List<dynamic> updatedData = await DBController(context: context)
            .getUser(_textFieldController.text);
        widget.updateUserData(updatedData[0]);
        setState(() {
          email = updatedData[0]['email'];
        });
        Navigator.of(context).pop();
      }
    }
  }

  void changeEmail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(shape8),
          ),
        ),
        title: Text(
          "Ubah Email",
          style: CustomTextStyle().heading16(textDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textFieldController,
              cursorColor: textDark,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textDark),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textDark),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: secondaryColor),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _textFieldController.text = widget.userData['email'];
              });
            },
            child: Text(
              'Kembali',
              style: TextStyle(color: primaryColor),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: secondaryColor),
            onPressed: handleChangeEmail,
            child: Text(
              'Ubah',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: CustomTextStyle().heading16(textDark)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
        ),
        shape: BorderDirectional(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(shape36),
        child: Column(
          children: [
            Icon(Icons.account_circle, size: logo96, color: primaryColor),
            SizedBox(height: shape16),
            Text(
              email,
              textAlign: TextAlign.center,
              style: CustomTextStyle().heading16(textDark),
            ),
            SizedBox(height: shape36),
            FilledButton(
              onPressed: changeEmail,
              style: FilledButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(shape8),
                  ),
                  side: BorderSide(color: primaryColor),
                ),
                minimumSize: const Size(double.infinity, 60),
                padding: EdgeInsets.all(shape16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail, color: primaryColor),
                  SizedBox(width: shape8),
                  Text(
                    "Ubah Email",
                    style: CustomTextStyle().heading16(primaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: shape16),
            FilledButton(
              onPressed: handleLogout,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(shape8),
                  ),
                ),
                minimumSize: const Size(double.infinity, 60),
                padding: EdgeInsets.all(shape16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: bgColor),
                  SizedBox(width: shape8),
                  Text(
                    "Keluar",
                    style: CustomTextStyle().heading16(bgColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: shape36),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '"Tidak ada yang tidak mungkin jika kita mau berusaha dan berdoa."',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle().normal12(textLight),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/images/illustration.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
