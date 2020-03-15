import 'package:flutter/material.dart';
import 'package:task_management/Animation/FadeAnimation.dart';
import '../data/moor_database.dart';
import 'package:provider/provider.dart';

import 'note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTaskList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail('Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    return StreamBuilder(
      stream: database.watchAllTasks(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, database);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, AppDatabase database) {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return FadeAnimation(
        1,
        Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(itemTask.priority),
              child: getPriorityIcon(itemTask.priority),
            ),
            title: Container(
              child: Column(children: [
                Row(children: <Widget>[
                  Text("Title : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    itemTask.name,
                    style: titleStyle,
                  )
                ]),
                Row(children: <Widget>[
                  Text("Note : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    itemTask.description,
                    style: titleStyle,
                  )
                ])
              ]),
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                database.deleteTask(itemTask);
              },
            ),
          ),
        ));
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.lightBlueAccent;
        break;
      case 3:
        return Colors.lightGreenAccent;
        break;
      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.offline_bolt);
        break;
      case 2:
        return Icon(Icons.add_alert);
        break;
      case 3:
        return Icon(Icons.sentiment_satisfied);
        break;
      default:
        return Icon(Icons.offline_pin);
    }
  }

  void navigateToDetail(String title) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title);
    }));
  }
}
