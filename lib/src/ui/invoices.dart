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
  Text title;

  @override
  void initState() {
    widget._invoiceBloc.init();
    widget._invoiceBloc.fetchAllInvoices();
    _updateTitle(0);
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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: title,
      leading: Icon(Icons.event),
    );
  }

  Container _buildBody() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[_buildSeachTextField(), _buildList()],
      ),
    );
  }

  TextField _buildSeachTextField() {
    return TextField(
      decoration: InputDecoration(hintText: "Search"),
    );
  }

  Expanded _buildList() {
    return Expanded(
        child: PageView.builder(
      onPageChanged: (int page) => _updateTitle(page),
      reverse: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int page) {
        return _buildStreamBuilder(page);
      },
    ));
  }

  StreamBuilder<InvoiceResult> _buildStreamBuilder(int page) {
    return StreamBuilder(
      stream: widget._invoiceBloc.allInvoices,
      builder: (context, AsyncSnapshot<InvoiceResult> snapshot) {
        bool canBuildListView = snapshot.hasData || invoiceResult != null;
        if (canBuildListView) {
          if (snapshot.hasData) invoiceResult = snapshot.data;
          return _buildInvoiceListView(page);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ListView _buildInvoiceListView(int page) {
    return ListView.builder(
      itemCount: invoiceResult.total,
      itemBuilder: (BuildContext context, int index) {
        return _buildInvoiceItem(context, index, page);
      },
    );
  }

  ListTile _buildInvoiceItem(BuildContext context, int index, int page) {
    return ListTile(
      title: Text(invoiceResult.results[index].description),
      subtitle: Text(invoiceResult.results[index].valueFormated),
      trailing: Text(
        invoiceResult.results[index].dayDue.toString(),
        style: TextStyle(fontSize: 16),
      ),
      onLongPress: () => _showInvoiceMenu(context),
      leading: _buildIcon(index, page),
    );
  }

  void _showInvoiceMenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.check),
                    title: new Text('Flag payment'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () => {},
                ),
                new ListTile(
                  leading: new Icon(Icons.delete),
                  title: new Text('Delete'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  Icon _buildIcon(int index, int page) {
    return Icon(
        invoiceResult.results[index].checkIfWasPayed(_getNewPaymentDate(page))
            ? Icons.check
            : Icons.error);
  }

  void _updateTitle(int page) {
    setState(() {
      var paymentDate = _getNewPaymentDate(page);
      title = Text("Payments of ${paymentDate.month}/${paymentDate.year}");
    });
  }

  DateTime _getNewPaymentDate(int page) {
    var dateNow = DateTime.now();
    return DateTime(dateNow.year, dateNow.month - page, dateNow.day);
  }
}
