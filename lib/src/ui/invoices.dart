import 'package:flutter/material.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/models/invoice.dart';

class Invoices extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;

  Invoices(this._invoiceBloc);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  List<Invoice> invoices;
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
    invoices = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/NewInvoice'),
        tooltip: 'New invoice',
        child: Icon(Icons.add),
      ),
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
        children: <Widget>[_buildList()],
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

  StreamBuilder<List<Invoice>> _buildStreamBuilder(int page) {
    return StreamBuilder(
      stream: widget._invoiceBloc.allInvoices,
      builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {
        bool canBuildListView = snapshot.hasData || invoices != null;
        if (canBuildListView) {
          if (snapshot.hasData) invoices = snapshot.data;
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
      itemCount: invoices.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildInvoiceItem(context, index, page);
      },
    );
  }

  ListTile _buildInvoiceItem(BuildContext context, int index, int page) {
    return ListTile(
      title: Text(invoices[index].description),
      subtitle: Text(invoices[index].valueFormated),
      trailing: Text(
        invoices[index].dueDay.toString(),
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
                _buildInvoiceMenuItemDelete(index, buildContext),
              ],
            ),
          );
        });
  }

  Container _buildInvoiceMenuTitle(int index) {
    return Container(
        child: Text(
          invoices[index].description,
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

  ListTile _buildInvoiceMenuItemDelete(int index, BuildContext buildContext) {
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text('Delete'),
      onTap: () {
        widget._invoiceBloc.delete(invoices[index].id);
        setState(() {
          invoices.removeAt(index);
        });
        Navigator.pop(buildContext);
      },
    );
  }

  Icon _buildInvoiceMenuItemFlagPaymentIcon(int index, int page) {
    return invoices[index].checkIfWasPayed(_getNewPaymentDate(page))
        ? Icon(Icons.error)
        : Icon(Icons.check);
  }

  Text _buildInvoiceMenuItemFlagPaymentTitle(int index, int page) {
    return invoices[index].checkIfWasPayed(_getNewPaymentDate(page))
        ? Text("Flag no payment")
        : Text("Flag payment");
  }

  void setPaymentDate(int index, int page) {
    setState(() {
      var paymentDate = _getNewPaymentDate(page);
      var invoice = invoices[index];
      widget._invoiceBloc.updatePaymentDate(invoice, paymentDate);
    });
  }

  Icon _buildIcon(int index, int page) {
    return Icon(invoices[index].checkIfWasPayed(_getNewPaymentDate(page))
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
