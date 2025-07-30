import 'package:flutter/material.dart';

Widget endDrawer(BuildContext context) {
  final _textController = TextEditingController();
  bool isVisible = false;
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 25),
              ),
              SizedBox(width: 10),
              Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.language, color: Colors.green),
          title: Text(
            'Language',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  titlePadding: EdgeInsets.all(20),
                  shape: BeveledRectangleBorder(),
                  title: Text(
                    'Language',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'This Application based on Translate English to Yoruba Language and vice versa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.mode_night_outlined, color: Colors.green),
          title: Text(
            'About Us',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  titlePadding: EdgeInsets.all(20),
                  shape: BeveledRectangleBorder(),
                  title: Text(
                    'About Us',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'This Application was developed by:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'OGUNFOLAJIN FUNSHO OJO \n HC20230100949 \n\n Supervise by: \n MRS FABIYI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip, color: Colors.green),
          title: Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  titlePadding: EdgeInsets.all(20),
                  shape: BeveledRectangleBorder(),
                  title: Text(
                    'Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  content: Text('This application is meat for educational purpose', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.feedback, color: Colors.green),
          title: Text(
            'Feedback',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: BeveledRectangleBorder(),
                  titlePadding: EdgeInsets.all(10),
                  title: Text('Feedback', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  content: TextField(
                    maxLines: 5,
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    cursorColor: Colors.green,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback here',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_textController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter your feedback', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            )
                          );
                        }else {
                          _textController.clear();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Thank you for your feedback', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: BeveledRectangleBorder(),
                            ),
                          );
                        }
                      },
                      child: Text('SEND'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Spacer(),
        Text('Version 1.0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
      ],
    ),
  );
}
