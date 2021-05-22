import 'package:contacts/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'contactCreatePage.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  ContactDetailPage({Key key, @required this.contact}) : super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              primary: true,
              actions: [
                _simplePopup(context),
              ],
              expandedHeight:
                  widget.contact.avatar == null ? height / 3.4 : height / 3,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Colors.lightBlueAccent[700],
                      child: widget.contact.avatar == null
                          ? Icon(
                              Icons.account_circle,
                              size: height / 4.7,
                              color: Colors.white,
                            )
                          : Image(
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
                              image: NetworkImage(thumbCreate(widget.contact)),
                            ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, right: 19),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            color: Colors.white,
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.star_border,
                              color: Colors.amber[600],
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Icon(
                                    Icons.account_box,
                                    size: 40,
                                    color: Colors.greenAccent[700],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 20, top: 10),
                                  child: Text(
                                    widget.contact.name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 35,
                                  color: Colors.blueAccent[700],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 20, top: 25),
                                  child: Text(
                                    widget.contact.num.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 35,
                                  color: Colors.redAccent[700],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 20, top: 25),
                                  child: Text(
                                    widget.contact.email,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height - 250,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  deleteContact(Contact contact) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var fieldDeleturl =
        Uri.parse('http://10.0.2.2:1337/contacts/${contact.id}');

    if (contact.avatar == null) {
      var response = await http.delete(fieldDeleturl, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');

        return false;
      }
    } else {
      var imagedeleteUrl =
          Uri.parse('http://10.0.2.2:1337/upload/files/${contact.avatar.id}');
      var deleteImageResponse =
          await http.delete(imagedeleteUrl, headers: headers);
      if (deleteImageResponse.statusCode == 200) {
        print("silme başarılı");
        var response = await http.delete(fieldDeleturl, headers: headers);
        print("ontapped bottom ");
        if (response.statusCode == 200) {
          return true;
        } else {
          print('Request failed with status: ${response.statusCode}.');

          return false;
        }
      } else {
        print("image deletesorun olustu");
        print(deleteImageResponse.statusCode);
        return false;
      }
    }
  }

  Widget _simplePopup(BuildContext context) => PopupMenuButton<int>(
        onSelected: (value) async {
          if (value == 1) {
            var data = await deleteContact(widget.contact);

            if (data == true) {
              Fluttertoast.showToast(
                  msg: "Tebrikler ürün başarıyla Silindi",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.green[700],
                  textColor: Colors.white,
                  fontSize: 16.0);
              await Future.delayed(Duration(milliseconds: 450));
              Navigator.of(context).pop(true);
            } else {
              Fluttertoast.showToast(
                  msg: "Silerken hata oluştu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.redAccent[700],
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else if (value == 2) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ContactCreatePage(fromUpdate: true,contact: widget.contact,)));
          }
        },
        tooltip: "Engelleme ve Destek alma",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        icon: Icon(
          Icons.more_vert,
          size: 30,
          color: Colors.white,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Container(
                child: Text(
              "Delete  🗑️",
            )),
          ),
          PopupMenuItem(
            value: 2,
            child: Container(
                child: Text(
              "Update ",
            )),
          ),
        ],
      );

  String thumbCreate(Contact oneContact) {
    if (oneContact.avatar.formats.medium != null) {
      return "http://10.0.2.2:1337/uploads/" +
          oneContact.avatar.formats.medium.hash +
          ".jpg";
    } else {
      return "http://10.0.2.2:1337/uploads/" + oneContact.avatar.hash + ".jpg";
    }
  }
}
