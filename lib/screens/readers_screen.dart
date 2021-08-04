import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/data_static.dart';
import 'package:esprit_ebook_app/models/reader.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:esprit_ebook_app/widgets/favorie_item.dart';
import 'package:esprit_ebook_app/widgets/reader_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReaderScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  ReaderScreen({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';

  List<Reader> topReader = [];
  Reader myPosition;
  int myIndex = 0;
  bool _isLoading = true;
  void loadPageInfo() async {
    final String url = '${GlobalConfiguration().getString('base_url')}top';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var jsonResponse = null;
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $value"
    });
    print("APi Response Status : " + response.statusCode.toString());
    print("APi Response : " + response.body.toString());
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          topReader = (jsonResponse["users"] as List)
              .map((data) => new Reader.fromJson(data))
              .toList();
          print("--------------> "+topReader.length.toString());
          myIndex = jsonResponse["index"];
          if(myIndex != -1){
            myPosition = Reader.fromJson(jsonResponse["user"]);
          }else{
            myPosition = new Reader();
            myPosition.user = AppConfig.MAIN_USER;
            myPosition.id = 0;
            myPosition.books = 0;
          }
          myIndex++;
           _isLoading = false;
        });
      }
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPageInfo();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _isLoading? CircularProgressIndicator():Container(
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
                  Icons.favorite,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Top 100 Readers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Tops 100 Users Reader...",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.7),
                  borderRadius: BorderRadius.circular(38.5),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 33,
                      color: Color(0xFFD3D3D3).withOpacity(.84),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(38.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: kProgressIndicator.withOpacity(1),
                                backgroundImage: NetworkImage(urlimg+myPosition.user.avatar),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      myPosition.user.fname+ " "+myPosition.user.lname,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "My Points : "+myPosition.user.point.toString(),
                                      style: TextStyle(
                                        color: kLightBlackColor,
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                      Alignment.bottomRight,
                                      child: Text(
                                        myPosition.books.toString()+" Books",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: kLightBlackColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.all(5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(38.5),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 5,
                                      color: Color(0xFFD3D3D3).withOpacity(.84),
                                    ),
                                  ],
                                ),
                                child: Center(child: Text(myIndex.toString())),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: topReader.length,
                itemBuilder: (context, index) {
                  return ReaderItemWidget(
                    cart: topReader.elementAt(index),
                    heroTag: 'cart',
                    index: index,
                  );
                },
              ),
            ),

            // Container(
            //   margin: EdgeInsets.all(10),
            //   child: ListView.separated(
            //     padding: EdgeInsets.symmetric(vertical: 15),
            //     scrollDirection: Axis.vertical,
            //     shrinkWrap: true,
            //     primary: false,
            //     itemCount: carts.length,
            //     separatorBuilder: (context, index) {
            //       return SizedBox(height: 15);
            //     },
            //     itemBuilder: (context, index) {
            //       return ReaderItemWidget(
            //         cart: carts.elementAt(index),
            //         heroTag: 'cart',
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
