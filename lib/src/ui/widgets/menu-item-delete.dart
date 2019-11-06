import 'package:flutter/material.dart';

class MenuItemDelete extends StatelessWidget {
  const MenuItemDelete({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text('Delete'),
      onTap: onTap,
    );
  }
}
