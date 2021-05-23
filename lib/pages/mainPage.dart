import 'package:contacts/model/contact_model.dart';
import 'package:contacts/pages/contactDetail.dart';
import 'package:contacts/services/contactServices.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'contactCreatePage.dart';

class ContactsUserMainPage extends StatefulWidget {
  @override
  _ContactsUserMainPageState createState() => _ContactsUserMainPageState();
}

class _ContactsUserMainPageState extends State<ContactsUserMainPage> {
  ContactServices contactServices = ContactServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50, right: 14),
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ContactCreatePage(
                          fromUpdate: false,
                        )))
                .then((value) async => {
                      if (value == true)
                        {
                          await Future.delayed(Duration(milliseconds: 400)),
                          setState(() {})
                        }
                    });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 12),
              child: Text(
                "My Contact",
                style:
                    TextStyle(fontSize: 25, color: Colors.lightBlueAccent[700]),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => ContactCreatePage(
                              fromUpdate: false,
                            )))
                    .then((value) async => {
                          if (value == true)
                            {
                              await Future.delayed(Duration(milliseconds: 400)),
                              setState(() {})
                            }
                        });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.person_add,
                      color: Colors.greenAccent[700],
                      size: 35,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, bottom: 18, left: 15),
                      child: Text(
                        "Create New Contact",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
                future: contactServices.getContacts(),
                builder: (BuildContext context, AsyncSnapshot snaphsot) {
                  if (snaphsot.hasData) {
                    List<Contact> contact = snaphsot.data;

                    if (contact.length > 0) {
                      return Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: contact.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Contact oneContact = contact[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(PageTransition(
                                              child: ContactDetailPage(
                                                contact: oneContact,
                                              ),
                                              duration:
                                                  Duration(milliseconds: 210),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                            ))
                                            .then((value) async => {
                                                  if (value == true)
                                                    {
                                                      await Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  400)),
                                                      setState(() {})
                                                    }
                                                });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 8.0),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: oneContact.avatar == null
                                                  ? Icon(
                                                      Icons.account_circle,
                                                      color: Colors.grey[800],
                                                      size: 62,
                                                    )
                                                  : Image(
                                                      height: 58,
                                                      width: 58,
                                                      image: NetworkImage(
                                                          thumbCreate(
                                                              oneContact)),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              oneContact.name,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 19),
                                            ),
                                            SizedBox(width: 50),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "There is no contact add one",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  String thumbCreate(Contact oneContact) {
    if (oneContact.avatar.formats.medium != null) {
      return "http://10.0.2.2:1337/uploads/" +
          oneContact.avatar.formats.medium.hash +
          ".jpg";
    } else {
      return "http://10.0.2.2:1337/uploads/" +
          oneContact.avatar.formats.thumbnail.hash +
          ".jpg";
    }
  }
}
