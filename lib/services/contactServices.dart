import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:contacts/commonWidget/commons.dart';
import 'package:contacts/constant/contstant.dart';
import 'package:contacts/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:contacts/pages/contactCreatePage.dart';

class ContactServices {
  CommonWidgets commonWidgets = CommonWidgets();

  Future<Avatar> uploadImage(
      String imageFilePath,
      Uint8List imageBytes,
      BuildContext context,
      bool fromUpdate,
      ContactCreatePage widget,
      String name,
      String num,
      String email,
      File _image) async {
    if (fromUpdate == false) {
      String url = SERVERURL + "/upload/";

      await uploadImageMethods(imageFilePath, imageBytes, context, url, name,
          num, email, widget, _image, fromUpdate);
      commonWidgets.customToast("Congratulations contact added successfully",
          Colors.greenAccent[700]);

      await Future.delayed(Duration(milliseconds: 350));
      Navigator.of(context).pop(true);
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
        var deleteImageResponse =
            await http.delete(Uri.parse(deleteImageurl), headers: headers);

        if (deleteImageResponse.statusCode == 200) {
          avatar = await uploadImageMethods(imageFilePath, imageBytes, context,
              updateImageurl, name, num, email, widget, _image, fromUpdate);

          commonWidgets.customToast(
              "Congratulations product has been successfully updated",
              Colors.greenAccent[700]);

          await Future.delayed(Duration(milliseconds: 350));
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/mainPage', (Route<dynamic> route) => false);
        } else {
          print("error occured  ${deleteImageResponse.statusCode}");
        }
      } else if (widget.contact.avatar == null) {
        PickedFile imageFile = PickedFile(imageFilePath);
        var stream =
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

        var uri = Uri.parse(updateImageurl);
        int length = imageBytes.length;
        var request = new http.MultipartRequest("POST", uri);

        var multipartFile = new http.MultipartFile('files', stream, length,
            filename: basename(imageFile.path),
            contentType: MediaType('image', 'png'));
        request.files.add(multipartFile);
        var response = await request.send();

        print(response.statusCode);
        response.stream.transform(utf8.decoder).listen((value) async {
          String gelendata = value;

          var fromList = avatarfromlist(gelendata);
          avatar = fromList[0];
          var gelenDatam = await createContact(
              avatar, true, name, num, email, widget.contact);
          if (gelenDatam != null) {
            if (gelenDatam == true) {
              commonWidgets.customToast(
                  "Congratulations product has been successfully updated",
                  Colors.greenAccent[700]);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/mainPage', (Route<dynamic> route) => false);
            } else {}
          }
        });
      }
    }
  }

  createContact(Avatar avatar, bool fromUpdate, String name, String num,
      String email, Contact contacts) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    if (fromUpdate == false) {
      var url = Uri.parse('$SERVERURL/contacts');
      Contact contact =
          Contact(name: name, num: num, avatar: avatar, email: email);

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');

        return false;
      }
    } else {
      var url = Uri.parse('$SERVERURL/contacts/${contacts.id}');
      Contact contact =
          Contact(name: name, num: num, avatar: avatar, email: email);

      var response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(contact.toJson()),
      );
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');

        return false;
      }
    }
  }

  uploadImageMethods(
    String imageFilePath,
    Uint8List imageBytes,
    BuildContext context,
    String uploadImageUrl,
    String name,
    String num,
    String email,
    ContactCreatePage widget,
    File image,
    bool fromUpdate,
  ) async {
    Avatar avatar = Avatar();
    PickedFile imageFile = PickedFile(imageFilePath);
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

    var uri = Uri.parse(uploadImageUrl);
    int length = imageBytes.length;
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('files', stream, length,
        filename: basename(imageFile.path),
        contentType: MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) async {
      String gelendata = value;

      var fromList = avatarfromlist(gelendata);
      avatar = fromList[0];

      var gelenDatam = await createContact(
          avatar, fromUpdate, name, num, email, widget.contact);
      if (gelenDatam != null) {
        if (gelenDatam == true) {
          return avatar;
        } else {
          print("error data added");
        }
      }
    });
  }

  deleteContact(Contact contact) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var fieldDeleturl = Uri.parse('$SERVERURL/contacts/${contact.id}');

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
          Uri.parse('$SERVERURL/upload/files/${contact.avatar.id}');
      var deleteImageResponse =
          await http.delete(imagedeleteUrl, headers: headers);
      if (deleteImageResponse.statusCode == 200) {
        var response = await http.delete(fieldDeleturl, headers: headers);
        if (response.statusCode == 200) {
          return true;
        } else {
          print('Request failed with status: ${response.statusCode}.');

          return false;
        }
      } else {
        print(deleteImageResponse.statusCode);
        return false;
      }
    }
  }

  getContacts() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var url = Uri.parse('$SERVERURL/contacts');

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      List<Contact> contact = contactFromJson(jsonString);
      return contact.reversed.toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');

      return null;
    }
  }
}
