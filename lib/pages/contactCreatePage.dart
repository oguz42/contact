import 'dart:convert';
import 'dart:io';

import 'package:contacts/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

const SERVERURL = 'http://10.0.2.2:1337';

class ContactCreatePage extends StatefulWidget {
  final bool fromUpdate;
  final Contact contact;

  ContactCreatePage({@required this.fromUpdate, this.contact});

  @override
  _ContactCreatePageState createState() => _ContactCreatePageState();
}

class _ContactCreatePageState extends State<ContactCreatePage> {
  TextEditingController controllerContactName = TextEditingController();
  TextEditingController controllerContactNumber = TextEditingController();
  TextEditingController controllerContactEmail = TextEditingController();
  File _image;
  double height, width;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    if (widget.fromUpdate) {
      controllerContactEmail.text = widget.contact.email;
      controllerContactName.text = widget.contact.name;
      controllerContactNumber.text = widget.contact.num;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Contact Create"),
        backgroundColor: Colors.pinkAccent[700],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 120,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: Colors.pinkAccent,
                                      size: 35,
                                    ),
                                    title: Text("Pick Image From Camera"),
                                    onTap: () {
                                      getImageFromCamera(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.image,
                                      color: Colors.greenAccent,
                                      size: 35,
                                    ),
                                    title: Text("Get Image From Gallery"),
                                    onTap: () {
                                      getImageFromGallery(context);
                                    },
                                  ),
                                ]),
                          );
                        });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: _image == null
                        ? Container(
                            height: 120,
                            width: 120,
                            color: Colors.lightBlueAccent,
                            child: widget.fromUpdate &&
                                    widget.contact.avatar != null
                                ? Image.network(
                                    "http://10.0.2.2:1337/uploads/" +
                                        widget.contact.avatar.hash +
                                        ".jpg",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                          )
                        : Image(
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                            image: imageWidgetAta()
                            // : FileImage(_image),
                            ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerContactName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Name/Surname"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerContactNumber,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Num"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerContactEmail,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "email"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  if (widget.fromUpdate == false) {
                    if (controllerContactName.text.trim().isNotEmpty &&
                        controllerContactNumber.text.trim().isNotEmpty &&
                        controllerContactEmail.text.trim().isNotEmpty) {
                      if (_image != null) {
                        uploadImage(_image.path, _image.readAsBytesSync(),
                            context, false);
                      } else {
                        var data = await createContact(null, false);
                        if (data == true) {
                          Fluttertoast.showToast(
                              msg: "Tebrikler ürün başarıyla eklendi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.green[700],
                              textColor: Colors.white,
                              fontSize: 16.0);
                          //   Navigator.of(context).pop(true);
                          print("veri başarıyla eklendi");
                          await Future.delayed(Duration(milliseconds: 350));
                          Navigator.of(context).pop(true);
                        } else {
                          print("veri eklerken hata");
                        }
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Alanlar Boş Olamaz",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.redAccent[700],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } else {
                    if (_image != null) {
                      uploadImage(
                          _image.path, _image.readAsBytesSync(), context, true);
                    } else {
                      var data = await createContact(null, true);
                      if (data == true) {
                        Fluttertoast.showToast(
                            msg: "Tebrikler ürün başarıyla güncellendi",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.green[700],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        //   Navigator.of(context).pop(true);
                        print("veri başarıyla güncellendi");
                        await Future.delayed(Duration(milliseconds: 350));
                        Navigator.of(context).pop(true);
                      } else {
                        print("veri eklerken hata");
                      }
                    }
                  }
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Add",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.greenAccent[700],
                      borderRadius: BorderRadius.circular(15)),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 200,
                ),
              ),
              SizedBox(
                height: height / 2.9,
              )
            ],
          ),
        ),
      ),
    );
  }

  createContact(Avatar avatar, bool fromUpdate) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    if (!fromUpdate) {
      var url = Uri.parse('$SERVERURL/contacts');
      Contact contact = Contact(
          name: controllerContactName.text.trim(),
          num: controllerContactNumber.text.trim(),
          avatar: avatar,
          email: controllerContactEmail.text.trim());

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        print("veriler eklendi");
        print(response.body);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');

        return false;
      }
    } else {
      var url = Uri.parse('$SERVERURL/contacts/${widget.contact.id}');
      Contact contact = Contact(
          name: controllerContactName.text.trim(),
          num: controllerContactNumber.text.trim(),
          avatar: avatar,
          email: controllerContactEmail.text.trim());

      var response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        print("veriler eklendi");
        print(response.body);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');

        return false;
      }
    }
  }

  getImageFromCamera(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  getImageFromGallery(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future<Avatar> uploadImage(String imageFilePath, Uint8List imageBytes,
      BuildContext context, bool fromUpdate) async {
    if (fromUpdate == false) {
      Avatar avatar = Avatar();

      String url = SERVERURL + "/upload/";
      PickedFile imageFile = PickedFile(imageFilePath);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

      var uri = Uri.parse(url);
      int length = imageBytes.length;
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('files', stream, length,
          filename: basename(imageFile.path),
          contentType: MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();

      print("response avatar kodları");

      print(response.statusCode);
      print("dolamadan once avatar");
      print(avatar.id);
      response.stream.transform(utf8.decoder).listen((value) async {
        print("gelen değerler createden");

        String gelendata = value;
        print(gelendata);

        var fromList = avatarfromlist(gelendata);
        avatar = fromList[0];
        print("dolan avatar");
        print(avatar.id);
        var gelenDatam = await createContact(avatar, false);
        if (gelenDatam != null) {
          print("avatar null degil");
          if (gelenDatam == true) {
            Fluttertoast.showToast(
                msg: "Tebrikler ürün başarıyla eklendi",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.green[700],
                textColor: Colors.white,
                fontSize: 16.0);
            //   Navigator.of(context).pop(true);
            print("veri başarıyla eklendi");
            await Future.delayed(Duration(milliseconds: 350));
            Navigator.of(context).pop(true);
          } else {
            print("veri eklerken hata upload image");
          }
        }
      });
    } else {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      String updateImageurl = SERVERURL + "/upload/";
      Avatar avatar = Avatar();

      if (widget.contact.avatar != null) {
        String deleteImageurl =
            SERVERURL + "/upload/files/${widget.contact.avatar.id}";
        print(deleteImageurl);
        print("update image url");
        var deleteImageResponse =
            await http.delete(Uri.parse(deleteImageurl), headers: headers);

        if (deleteImageResponse.statusCode == 200) {
          PickedFile imageFile = PickedFile(imageFilePath);
          print("görsel yolu alındı");
          var stream =
              new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
          print("görsel okundu");

          var uri = Uri.parse(updateImageurl);
          print("uri parse edildi");
          int length = imageBytes.length;
          var request = new http.MultipartRequest("POST", uri);

          var multipartFile = new http.MultipartFile('files', stream, length,
              filename: basename(imageFile.path),
              contentType: MediaType('image', 'png'));
          print("mdei type veridi");
          print(imageFile.path);
          print("image file pathi üsttü yazıldı");

          // request.fields.addAll({
          //   "field":"avatar",
          //   "refId":"${widget.contact.id.toString()}",
          //   "ref":"contacts"
          // });

          request.files.add(multipartFile);
          var response = await request.send();

          print(response.statusCode);
          response.stream.transform(utf8.decoder).listen((value) async {
            print("gelen eğerler upadateden");
            print("görsel yüklendi");
            print(value);
            String gelendata = value;
            print(gelendata);

            var fromList = avatarfromlist(gelendata);
            avatar = fromList[0];
            var gelenDatam = await createContact(avatar, true);
            if (gelenDatam != null) {
              print("avatar null degil");
              if (gelenDatam == true) {
                Fluttertoast.showToast(
                    msg: "Tebrikler ürün başarıyla güncellendi",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.green[700],
                    textColor: Colors.white,
                    fontSize: 16.0);
                //   Navigator.of(context).pop(true);
                print("veri başarıyla güncellendi");
                await Future.delayed(Duration(milliseconds: 350));
                Navigator.of(context).pop(true);
              } else {
                print("veri eklerken hata upload image");
              }
            }
          });
        } else {
          print(
              "silinirken güncelleme sırasında hata  ${deleteImageResponse.statusCode}");
        }
      } else {
        PickedFile imageFile = PickedFile(imageFilePath);
        print("görsel yolu alındı");
        var stream =
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        print("görsel okundu");

        var uri = Uri.parse(updateImageurl);
        print("uri parse edildi");
        int length = imageBytes.length;
        var request = new http.MultipartRequest("POST", uri);

        var multipartFile = new http.MultipartFile('files', stream, length,
            filename: basename(imageFile.path),
            contentType: MediaType('image', 'png'));
        print("mdei type veridi");
        print(imageFile.path);
        print("image file pathi üsttü yazıldı");

        // request.fields.addAll({
        //   "field":"avatar",
        //   "refId":"${widget.contact.id.toString()}",
        //   "ref":"contacts"
        // });

        request.files.add(multipartFile);
        var response = await request.send();

        print(response.statusCode);
        response.stream.transform(utf8.decoder).listen((value) async {
          print("gelen eğerler upadateden");
          print("görsel yüklendi");
          print(value);
          String gelendata = value;
          print(gelendata);

          var fromList = avatarfromlist(gelendata);
          avatar = fromList[0];
          var gelenDatam = await createContact(avatar, true);
          if (gelenDatam != null) {
            print("avatar null degil");
            if (gelenDatam == true) {
              Fluttertoast.showToast(
                  msg: "Tebrikler ürün başarıyla güncellendi",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.green[700],
                  textColor: Colors.white,
                  fontSize: 16.0);
              //   Navigator.of(context).pop(true);
              print("veri başarıyla güncellendi");
              await Future.delayed(Duration(milliseconds: 350));
              Navigator.of(context).pop(true);
            } else {
              print("veri eklerken hata upload image");
            }
          }
        });
      }
    }
  }

  imageWidgetAta() {
    if (widget.fromUpdate && _image != null) {
      return FileImage(_image);
    } else if (widget.fromUpdate == false) {
      return NetworkImage("http://10.0.2.2:1337/uploads/" +
          widget.contact.avatar.hash +
          ".jpg");
    }
  }
}
