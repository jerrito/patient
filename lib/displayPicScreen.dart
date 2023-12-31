import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/widgets/MainButton.dart';
// import 'package:mobile_money_project/Main_Page.dart';
import 'package:project/constants/Size_of_screen.dart';
// import 'package:mobile_money_project/resources/dimens.dart';
//import 'package:mobile_money_project/settings/profile_settings.dart';
import 'package:project/main.dart';
import 'package:project/profile.dart';
import 'package:project/userProvider.dart';
import 'package:provider/provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  //final Main_Page? main_page;
 final String imagePath;
  String? url;
  DisplayPictureScreen({super.key, required this.imagePath, this.url});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool saveLoading = false;
  Future<String?> uploadFile() async {
    File file = File(widget.imagePath);
    final storageReference =
        FirebaseStorage.instance.ref().child(number).child(widget.imagePath);

    final uploadTask = storageReference.putFile(file);
    String? returnURL;
    await uploadTask.whenComplete(() {
      //print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
        widget.url = returnURL;
        // print( widget.url.toString());
        // print("This is ${returnURL}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
                profileUpdate: ProfileUpdate(
              check: "update",
              imagePath: fileURL,
            )),
          ),
        );
        //returnURL=widget.URL;
        // setState(() {
        //   //widget.URL=returnURL;
        //   saveLoading = false;
        // });
      });
      return returnURL;
    });
    return null;
  }

  String number = "";
  UserProvider? userProvider;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    //print(userProvider?.appUser?.number);
    setState(() {
      number = userProvider!.appUser!.number!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Ayaresapa Profile Picture",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(229, 229, 229, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: SvgPicture.asset("./assets/svgs/x.svg"))),
              ]),

              SizedBox(
                height: h_s * 1.25,
              ),
              // Container(
              //   width: SizeConfig.screenWidth-60,height:300,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     image: DecorationImage(image: Image.file(
              //       File(widget.imagePath),
              //       fit: BoxFit.fill,
              //     ).image,
              //   ),),
              // ),
              CircleAvatar(
                radius: h_s * 18.75,
                backgroundImage: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ).image,
              ),
              SizedBox(height: h_s * 25), //SizeConfig.blockSizeVertical*15),
              Visibility(
                visible: saveLoading,
                replacement: SecondaryButton(
                  onPressed: saveLoading
                      ? null
                      : () async {
                          setState(() {
                            saveLoading = true;
                          });
                          uploadFile();
                        },
                  backgroundColor: Colors.pink,
                  color: Colors.pink,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                child: Center(
                    child: SpinKitFadingCube(
                  color: Colors.pink,
                  size: h_s * 6.25,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
