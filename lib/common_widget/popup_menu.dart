import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  PopUpMenu({this.onCreate, this.onEdit, this.onDelete});

  void showMenuSelection(String value) {
    switch (value) {
      case 'Create another':
        onCreate();
        break;
      case 'Edit':
        onEdit();
        break;
      case 'Delete':
        onDelete();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: 'Create another',
            child: ListTile(
                leading: Icon(Icons.add), title: Text('Create another'))),
        const PopupMenuItem<String>(
            value: 'Edit',
            child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
        const PopupMenuItem<String>(
            value: 'Delete',
            child: ListTile(leading: Icon(Icons.delete), title: Text('Delete')))
      ],
    );
  }
}
