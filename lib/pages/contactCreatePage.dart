import 'dart:io';
import 'package:contacts/commonWidget/commons.dart';
import 'package:contacts/model/contact_model.dart';
import 'package:contacts/services/contactServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  ContactServices contactServices = ContactServices();
  CommonWidgets commonWidgets = CommonWidgets();

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
                      child: Container(
                        width: 120,
                        height: 120,
                        color: Colors.lightBlueAccent,
                        child: imageWidgetAta(),
                      )),
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
                  String contactNameTrimed = controllerContactName.text.trim();
                  String contacNumberTrimed =
                      controllerContactNumber.text.trim();
                  String contactEmailTrimed =
                      controllerContactEmail.text.trim();

                  if (widget.fromUpdate == false) {
                    if (contactNameTrimed.isNotEmpty &&
                        contacNumberTrimed.isNotEmpty &&
                        contactEmailTrimed.isNotEmpty) {
                      if (_image != null) {
                        contactServices.uploadImage(
                            _image.path,
                            _image.readAsBytesSync(),
                            context,
                            false,
                            widget,
                            contactNameTrimed,
                            contacNumberTrimed,
                            contactEmailTrimed,
                            _image);
                      } else {
                        var data = await contactServices.createContact(
                            null,
                            false,
                            contactNameTrimed,
                            contacNumberTrimed,
                            contactEmailTrimed,
                            widget.contact);
                        if (data == true) {
                          commonWidgets.customToast(
                              "Congratulations contact added successfully",
                              Colors.greenAccent[700]);
                          Navigator.of(context).pop(true);
                        } else {
                          print("data added error");
                        }
                      }
                    } else {
                      commonWidgets.customToast(
                          "Fields cannot be empty", Colors.redAccent[700]);
                    }
                  } else {
                    if (widget.contact.avatar != null) {
                      if (_image != null) {
                        print("image null degil güncellenecek");
                        contactServices.uploadImage(
                            _image.path,
                            _image.readAsBytesSync(),
                            context,
                            true,
                            widget,
                            contactNameTrimed,
                            contacNumberTrimed,
                            contactEmailTrimed,
                            _image);
                      } else {

                        var data = await contactServices.createContact(
                            widget.contact.avatar,
                            true,
                            contactNameTrimed,
                            contacNumberTrimed,
                            contactEmailTrimed,
                            widget.contact);
                        if (data == true) {
                          commonWidgets.customToast(
                              "Congratulations contact added successfully",
                              Colors.greenAccent[700]);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/mainPage', (Route<dynamic> route) => false);
                        } else {
                          print("data added error");
                        }
                      }
                    } else {
                      if (_image != null) {
                        contactServices.uploadImage(
                            _image.path,
                            _image.readAsBytesSync(),
                            context,
                            true,
                            widget,
                            contactNameTrimed,
                            contacNumberTrimed,
                            contactEmailTrimed,
                            _image);
                      } else {
                        var data = await contactServices.createContact(
                            null,
                            true,
                            contactNameTrimed,
                            contacNumberTrimed,
                            contactEmailTrimed,
                            widget.contact);
                        if (data == true) {
                          commonWidgets.customToast(
                              "Congratulations contact added successfully",
                              Colors.greenAccent[700]);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/mainPage', (Route<dynamic> route) => false);
                        } else {
                          print("data added error");
                        }
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


  imageWidgetAta() {
    if (widget.fromUpdate == true) {
      if (widget.contact.avatar != null) {
        if (_image != null) {
          return Image(
            image: FileImage(_image),
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          );
        } else {
          return Image(
            image: NetworkImage("http://10.0.2.2:1337/uploads/" +
                widget.contact.avatar.hash +
                ".jpg"),
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          );
        }
      } else {
        if (_image != null) {
          return Image(
            image: FileImage(_image),
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          );
        } else {
          return Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          );
        }
      }
    } else {
      if (_image != null) {
        return Image(
          image: FileImage(_image),
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        );
      } else {
        return Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        );
      }
    }
  }
}
