import 'package:contacts/commonWidget/commons.dart';
import 'package:contacts/model/contact_model.dart';
import 'package:contacts/services/contactServices.dart';
import 'package:flutter/material.dart';



import 'contactCreatePage.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  ContactDetailPage({Key key, @required this.contact}) : super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  CommonWidgets commonWidgets = CommonWidgets();
  double height, width;
  ContactServices contactServices = ContactServices();

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
                                    style: TextStyle(fontSize: 16),
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
                                    style: TextStyle(fontSize: 16),
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
                                    style: TextStyle(fontSize: 16),
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

  Widget _simplePopup(BuildContext context) => PopupMenuButton<int>(
        onSelected: (value) async {
          if (value == 1) {
            var data = await contactServices.deleteContact(widget.contact);

            if (data == true) {
              commonWidgets.customToast(
                  "Congratulations contact successfully deleted",
                  Colors.greenAccent[700]);

              await Future.delayed(Duration(milliseconds: 450));
              Navigator.of(context).pop(true);
            } else {
              commonWidgets.customToast(
                  "Error occurred while deleting", Colors.redAccent[700]);
            }
          } else if (value == 2) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContactCreatePage(
                      fromUpdate: true,
                      contact: widget.contact,
                    )));
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
