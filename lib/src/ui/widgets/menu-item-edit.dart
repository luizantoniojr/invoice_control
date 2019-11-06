import 'package:flutter/material.dart';

class MenuItemEdit extends StatelessWidget {
  const MenuItemEdit({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Edit'),
      onTap: onTap,
    );
  }
}
