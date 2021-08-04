import 'dart:convert';
import 'dart:io';

import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAvatar extends StatefulWidget {
  @override
  _EditAvatarState createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  final String url =
      '${GlobalConfiguration().getString('img_server')}avatar/avatar.jpg';
  final String url2 =
      '${GlobalConfiguration().getString('img_server')}avatar/'+AppConfig.MAIN_USER.avatar;

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            height: 180.0,
            width: 180.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0x33A6A6A6)),
              image: DecorationImage(
                  image: Image.file(
                    snapshot.data,
                    fit: BoxFit.fill,
                  ).image,
                  fit: BoxFit.cover),
            ),
          );
        } else if (null != snapshot.error) {
          return Image.network(
            url,
          );
        } else {
          return Container(
              width: 180.0,
              height: 180.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(
                      url2))));
        }
      },
    );
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  uploadImage() {
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) async {
    print('Enter Upload Flutter');
    final String url = '${GlobalConfiguration().getString('base_url')}avatar';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    var jsonResponse = null;
    print(base64Image);
    var response = await http.post(url,
        headers: {"Authorization": "Bearer $value"},
        body: {"file": base64Image});
    print('Upload Success');
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      print(jsonResponse['ImageName'].toString());
      setState(() {
        AppConfig.MAIN_USER.avatar = jsonResponse['ImageName'];
      });

      Navigator.pop(context);
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => UserHome()),
      //     ModalRoute.withName("/Home"));
    } else {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => UserHome()),
      //     ModalRoute.withName("/Home"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bitmap.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Edit Avatar',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Upload Avatar",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    // width: 200,
                    //height: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 139, 198, 0.3),
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          )
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              chooseImage();
                            },
                            child: showImage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    onPressed: () {
                      uploadImage();
                    },
                    shape: StadiumBorder(),
                    textColor: Colors.white,
                    child: Text("Upload"),
                    color: kProgressIndicator,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: StadiumBorder(),
                      textColor: Colors.black,
                      child: Text("Cancel"),
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    // SingleChildScrollView(
    // child: Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     Container(
    //       height: 150,
    //       child: Stack(
    //         children: <Widget>[
    //           Positioned(
    //             top: -120,
    //             width: width,
    //             height: 250,
    //             child:
    //               Container(
    //                 decoration: BoxDecoration(
    //                     image: DecorationImage(
    //                         image: AssetImage(
    //                             'assets/images/background.png'),
    //                         fit: BoxFit.fill)),
    //               ),
    //           ),
    //           Positioned(
    //             height: 250,
    //             top: -90,
    //             width: width + 20,
    //             child:
    //               Container(
    //                 decoration: BoxDecoration(
    //                     image: DecorationImage(
    //                         image: AssetImage(
    //                             'assets/images/background-2.png'),
    //                         fit: BoxFit.fill)),
    //               ),
    //           ),
    //           Positioned(
    //             top: 35,
    //             left: 10,
    //             //width: width + 20,
    //             child: Container(
    //                 child: IconButton(
    //                     icon: Icon(
    //                       Icons.arrow_back_ios,
    //                       size: 30,
    //                     ),
    //                     color: Colors.white,
    //                     onPressed: () {
    //                       // Navigator.push(
    //                       //   context,
    //                       //   PageRouteBuilder(
    //                       //       pageBuilder: (_, a1, a2) => UserHome()),
    //                       // );
    //                     }),
    //               ),
    //           )
    //         ],
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 40),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Text(
    //             "Edit Avatar",
    //             style: TextStyle(
    //                 color: Color.fromRGBO(49, 39, 79, 1),
    //                 fontWeight: FontWeight.bold,
    //                 fontFamily: 'Raleway',
    //                 fontSize: 30),
    //           ),
    //           SizedBox(
    //             height: 40,
    //           ),
    //           Container(
    //             width: width,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(10),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Color.fromRGBO(196, 139, 198, 0.3),
    //                     blurRadius: 5,
    //                     offset: Offset(0, 0),
    //                   )
    //                 ]),
    //             child: Column(
    //               children: <Widget>[
    //                 Container(
    //                   padding: EdgeInsets.all(30),
    //                   decoration: BoxDecoration(
    //                       border: Border(
    //                           bottom:
    //                           BorderSide(color: Colors.grey[300]))),
    //                   child: InkWell(
    //                     onTap: () {
    //                       chooseImage();
    //                     },
    //                     child: showImage(),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 40,
    //           ),
    //             Container(
    //               height: 50,
    //               margin: EdgeInsets.symmetric(horizontal: 60),
    //               decoration: BoxDecoration(
    //                   color: Color.fromRGBO(49, 39, 79, 1),
    //                   borderRadius: BorderRadius.circular(50)),
    //               child: InkWell(
    //                 onTap: () {
    //                   print("Container clicked");
    //                   // // signUp(emailController.text,
    //                   // //     passwordController.text, _selected);
    //                   // uploadImage();
    //                 },
    //                 child: Center(
    //                   child: Text(
    //                     "Upload",
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //
    //           SizedBox(
    //             height: 30,
    //           ),
    //           Center(
    //             child: InkWell(
    //               onTap: () {
    //                 print('Tapped');
    //                 // Navigator.pushAndRemoveUntil(
    //                 //     context,
    //                 //     MaterialPageRoute(
    //                 //         builder: (context) => UserHome()),
    //                 //     ModalRoute.withName("/Home"));
    //               },
    //               child: Text(
    //                 "Cancel",
    //                 style: TextStyle(
    //                   color: Color.fromRGBO(49, 39, 79, 1),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // ),
  }
}
