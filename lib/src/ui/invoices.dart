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
    widget._invoiceBloc.fetchAll();
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
      onTap: () => _showInvoiceMenu(context, index, page),
      leading: _buildIcon(index, page),
    );
  }

  void _showInvoiceMenu(BuildContext context, int index, int page) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            padding: EdgeInsets.all(5.0),
            child: Wrap(
              children: <Widget>[
                _buildInvoiceMenuTitle(index),
                _buildInvoiceMenuItemFlagPayment(index, page, buildContext),
                _buildInvoiceMenuItemEdit(),
                _buildInvoiceMenuItemDelete(),
              ],
            ),
          );
        });
  }

  Container _buildInvoiceMenuTitle(int index) {
    return Container(
        child: Text(
          invoiceResult.results[index].description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.all(20.0));
  }

  ListTile _buildInvoiceMenuItemFlagPayment(
      int index, int page, BuildContext buildContext) {
    return ListTile(
        leading: _buildInvoiceMenuItemFlagPaymentIcon(index, page),
        title: _buildInvoiceMenuItemFlagPaymentTitle(index, page),
        onTap: () {
          setPaymentDate(index, page);
          Navigator.pop(buildContext);
        });
  }

  ListTile _buildInvoiceMenuItemEdit() {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Edit'),
      onTap: () => {},
    );
  }

  ListTile _buildInvoiceMenuItemDelete() {
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text('Delete'),
      onTap: () => {},
    );
  }

  Icon _buildInvoiceMenuItemFlagPaymentIcon(int index, int page) {
    return invoiceResult.results[index]
            .checkIfWasPayed(_getNewPaymentDate(page))
        ? Icon(Icons.error)
        : Icon(Icons.check);
  }

  Text _buildInvoiceMenuItemFlagPaymentTitle(int index, int page) {
    return invoiceResult.results[index]
            .checkIfWasPayed(_getNewPaymentDate(page))
        ? Text("Flag no payment")
        : Text("Flag payment");
  }

  void setPaymentDate(int index, int page) {
    setState(() {
      var paymentDate = _getNewPaymentDate(page);
      var invoice = invoiceResult.results[index];
      widget._invoiceBloc.updatePaymentDate(invoice, paymentDate);
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
