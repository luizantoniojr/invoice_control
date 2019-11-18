import 'package:flutter/material.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/models/invoice.dart';
import 'package:invoice_control/src/ui/widgets/invoice-list-tile.dart';
import 'package:invoice_control/src/ui/widgets/menu-bottom-sheet.dart';

import 'widgets/new-invoice-button.dart';

class Invoices extends StatefulWidget {
  final InvoiceBloc invoiceBloc;

  Invoices(this.invoiceBloc);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  List<Invoice> invoices;
  Text title;

  @override
  void initState() {
    widget.invoiceBloc.init();
    widget.invoiceBloc.fetchAll();
    _updateTitle(0);
    super.initState();
  }

  @override
  void didUpdateWidget(Invoices oldWidget) {
    widget.invoiceBloc.fetchAll();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.invoiceBloc.dispose();
    invoices = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title),
      body: _buildBody(),
      floatingActionButton: NewInvoiceButton(),
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
      stream: widget.invoiceBloc.allInvoices,
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
        return InvoiceListTile(
          invoices: invoices,
          context: context,
          index: index,
          page: page,
          onTap: _showInvoiceMenu,
          parent: widget,
        );
      },
    );
  }

  void _showInvoiceMenu(BuildContext context, int index, int page) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return MenuBottomSheet(
            invoices: invoices,
            widget: widget,
            buildContext: buildContext,
            index: index,
            page: page,
            onTapFlagPayment: () {
              setPaymentDate(index, page);
              Navigator.pop(buildContext);
            },
            onTapEdit: () {
              Navigator.pushNamed(context, '/NewInvoice',
                  arguments: invoices[index]);
            },
            onTapDelete: () {
              widget.invoiceBloc.delete(invoices[index].id);
              setState(() {
                invoices.removeAt(index);
              });
              Navigator.pop(buildContext);
            },
          );
        });
  }

  void setPaymentDate(int index, int page) {
    setState(() {
      var paymentDate = widget.invoiceBloc.getNewPaymentDate(page);
      var invoice = invoices[index];
      widget.invoiceBloc.updatePaymentDate(invoice, paymentDate);
    });
  }

  void _updateTitle(int page) {
    setState(() {
      var paymentDate = widget.invoiceBloc.getNewPaymentDate(page);
      title = Text("Payments of ${paymentDate.month}/${paymentDate.year}");
    });
  }
}
