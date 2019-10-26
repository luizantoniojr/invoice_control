import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/ui/invoices.dart';

class App extends StatelessWidget {
  final InvoiceBloc invoiceBloc;

  @provide
  App(this.invoiceBloc) : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice Control',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white70),
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {'/': (context) => Invoices(invoiceBloc)},
    );
  }
}
