import 'package:flutter/material.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';

class Invoices extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;

  Invoices(this._invoiceBloc);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  void initState() {
    widget._invoiceBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    widget._invoiceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice Control")),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: "Search"),
            ),
            // Expanded(child: FutureBuilder())
          ],
        ),
      ),
    );
  }
}
