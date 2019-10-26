import 'package:flutter/material.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/models/invoice-result.dart';

class Invoices extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;

  Invoices(this._invoiceBloc);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  InvoiceResult invoiceResult;

  @override
  void initState() {
    widget._invoiceBloc.init();
    widget._invoiceBloc.fetchAllInvoices();
    super.initState();
  }

  @override
  void dispose() {
    widget._invoiceBloc.dispose();
    invoiceResult = null;
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
            Expanded(
                child: PageView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int page) {
                return buildStreamBuilder(page);
              },
            ))
          ],
        ),
      ),
    );
  }

  StreamBuilder<InvoiceResult> buildStreamBuilder(int page) {
    return StreamBuilder(
      stream: widget._invoiceBloc.allInvoices,
      builder: (context, AsyncSnapshot<InvoiceResult> snapshot) {
        if (snapshot.hasData || invoiceResult != null) {
          if (snapshot.data != null) invoiceResult = snapshot.data;
          return ListView.builder(
            itemCount: invoiceResult.total,
            itemBuilder: (BuildContext context, int index) {
              return buildInvoiceItem(index, page);
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ListTile buildInvoiceItem(int index, int page) {
    var dateNow = DateTime.now();
    var paymentDate = DateTime(dateNow.year, dateNow.month - page, dateNow.day);

    return ListTile(
      title: Text(invoiceResult.results[index].description),
      subtitle: Text(invoiceResult.results[index].valueFormated),
      trailing: Text(
        invoiceResult.results[index].dayDue.toString(),
        style: TextStyle(fontSize: 16),
      ),
      onLongPress: () {},
      leading: Checkbox(
        value: invoiceResult.results[index].checkIfWasPayed(paymentDate),
      ),
    );
  }
}
