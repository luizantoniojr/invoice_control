import 'package:flutter/material.dart';
import 'package:invoice_control/src/models/invoice.dart';
import 'package:invoice_control/src/ui/invoices.dart';
import 'package:invoice_control/src/ui/widgets/menu-item-delete.dart';
import 'package:invoice_control/src/ui/widgets/menu-item-edit.dart';
import 'package:invoice_control/src/ui/widgets/menu-item-flag-payment.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({
    Key key,
    @required this.invoices,
    @required this.widget,
    @required this.index,
    @required this.page,
    @required this.buildContext,
    @required this.onTapFlagPayment,
    @required this.onTapEdit,
    @required this.onTapDelete,
  }) : super(key: key);

  final List<Invoice> invoices;
  final Invoices widget;
  final int index;
  final int page;
  final BuildContext buildContext;
  final Function onTapFlagPayment;
  final Function onTapEdit;
  final Function onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Wrap(
        children: <Widget>[
          _buildInvoiceMenuTitle(index),
          MenuItemFlagPayment(
            index: index,
            page: page,
            buildContext: buildContext,
            onTap: onTapFlagPayment,
            invoices: invoices,
            parent: widget,
          ),
          MenuItemEdit(onTap: onTapEdit),
          MenuItemDelete(onTap: onTapDelete),
        ],
      ),
    );
  }

  Container _buildInvoiceMenuTitle(int index) {
    return Container(
        child: Text(
          invoices[index].description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.all(20.0));
  }
}
