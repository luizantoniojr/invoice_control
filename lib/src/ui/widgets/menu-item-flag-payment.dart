import 'package:flutter/material.dart';
import 'package:invoice_control/src/models/invoice.dart';
import 'package:invoice_control/src/ui/invoices.dart';

class MenuItemFlagPayment extends StatelessWidget {
  const MenuItemFlagPayment({
    Key key,
    @required this.invoices,
    @required this.parent,
    @required this.index,
    @required this.page,
    @required this.buildContext,
    @required this.onTap,
  }) : super(key: key);

  final List<Invoice> invoices;
  final Invoices parent;
  final int index;
  final int page;
  final BuildContext buildContext;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: _buildInvoiceMenuItemFlagPaymentIcon(index, page),
        title: _buildInvoiceMenuItemFlagPaymentTitle(index, page),
        onTap: onTap);
  }

  Icon _buildInvoiceMenuItemFlagPaymentIcon(int index, int page) {
    return invoices[index]
            .checkIfWasPayed(parent.invoiceBloc.getNewPaymentDate(page))
        ? Icon(Icons.error)
        : Icon(Icons.check);
  }

  Text _buildInvoiceMenuItemFlagPaymentTitle(int index, int page) {
    return invoices[index]
            .checkIfWasPayed(parent.invoiceBloc.getNewPaymentDate(page))
        ? Text("Flag no payment")
        : Text("Flag payment");
  }
}
