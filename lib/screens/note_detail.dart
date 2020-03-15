import 'package:flutter/material.dart';
import 'package:task_management/Animation/FadeAnimation.dart';
import '../data/moor_database.dart';
import 'package:provider/provider.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;

  NoteDetail(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Medium', 'Low'];

  String title;
  String description;
  int priority = 1;
  String appBarTitle;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // First element
            ListTile(
              title: FadeAnimation(
                  1,
                  DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      })),
            ),

            // Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: FadeAnimation(
                  1,
                  TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Task',
                        labelStyle: textStyle,
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
            ),

            // Third Element
            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: FadeAnimation(
                  1,
                  TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Note',
                      labelStyle: textStyle,
                      prefixIcon: Icon(Icons.speaker_notes),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                )),

            // Fourth Element
            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Center(
                  child: FadeAnimation(
                      1,
                      RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                      )),
                )),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        priority = 1;
        break;
      case 'Medium':
        priority = 2;
        break;
      case 'Low':
        priority = 3;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Medium'
        break;
      case 3:
        priority = _priorities[2]; // 'Low'
        break;
    }
    return priority;
  }

  // Save data to database
  void _save() {
    if (title == null || description == null) {
      _showAlertDialog('Alert', 'Complete All Lable');
    } else {
      moveToLastScreen();
      final database = Provider.of<AppDatabase>(context);
      final task = Task(
        name: title,
        description: description,
        priority: priority,
      );
      database.insertTask(task);
      resetValuesAfterSubmit();
    }
  }

  void resetValuesAfterSubmit() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      priority = -1;
    });
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
