import 'package:flutter/material.dart';

class NewInvoiceButton extends StatelessWidget {
  const NewInvoiceButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/NewInvoice'),
      tooltip: 'New invoice',
      child: Icon(Icons.add),
    );
  }
}
