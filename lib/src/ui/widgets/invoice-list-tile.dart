import 'package:flutter/material.dart';
import 'package:invoice_control/src/models/invoice.dart';
import 'package:invoice_control/src/ui/invoices.dart';

class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile(
      {Key key,
      @required this.invoices,
      @required this.context,
      @required this.index,
      @required this.page,
      @required this.onTap,
      @required this.parent})
      : super(key: key);

  final List<Invoice> invoices;
  final BuildContext context;
  final int index;
  final int page;
  final Function onTap;
  final Invoices parent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(invoices[index].description),
      subtitle: Text(invoices[index].valueFormated),
      trailing: Text(
        invoices[index].dueDay.toString(),
        style: TextStyle(fontSize: 16),
      ),
      onTap: () => onTap(context, index, page),
      leading: _buildIcon(index, page),
    );
  }

  Icon _buildIcon(int index, int page) {
    return Icon(invoices[index]
            .checkIfWasPayed(parent.invoiceBloc.getNewPaymentDate(page))
        ? Icons.check
        : Icons.error);
  }
}
