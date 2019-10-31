import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/formatters/currency-formatter.dart';
import 'package:invoice_control/src/models/invoice.dart';

class InvoiceForm extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;

  InvoiceForm(this._invoiceBloc);

  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _description = new TextEditingController();
  final _value =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final _dueDay = new TextEditingController();
  Invoice _invoice;

  @override
  void initState() {
    _description.clear();
    _dueDay.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _invoice = ModalRoute.of(context).settings.arguments;
    setState(() {
      if (_invoice != null) {
        setValueInController(_description, _invoice.description.toString());
        setValueInController(_value, _invoice.value.toString());
        setValueInController(_dueDay, _invoice.dueDay.toString());
      }
    });

    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  void setValueInController(TextEditingController controller, String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(TextPosition(offset: value.length)),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Invoice"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              saveInvoice();
              Navigator.pushNamed(context, '/');
            }
          },
        )
      ],
    );
  }

  void saveInvoice() {
    if (_invoice == null) {
      widget._invoiceBloc.insert(Invoice(
          _description.text,
          CurrencyFormatter().formatToNumber(_value.text),
          int.parse(_dueDay.text)));
    } else {
      _invoice.description = _description.text;
      _invoice.value = CurrencyFormatter().formatToNumber(_value.text);
      _invoice.dueDay = int.parse(_dueDay.text);
      widget._invoiceBloc.update(_invoice);
    }
  }

  Container buildBody() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildDescriptionTextFormField(),
            buildValueTextFormField(),
            buildDueDayTextFormField()
          ],
        ),
      ),
    );
  }

  TextFormField buildDescriptionTextFormField() {
    return TextFormField(
      controller: _description,
      maxLength: 200,
      validator: (value) {
        if (value.isEmpty) {
          return 'Description is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Description *',
        hintText: 'Enter the description',
      ),
    );
  }

  TextFormField buildValueTextFormField() {
    return TextFormField(
      controller: _value,
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value) {
        if (value.isEmpty) {
          return 'Value is required';
        }
        if (CurrencyFormatter().formatToNumber(value) <= 0) {
          return 'Invalid value ';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Value *',
        hintText: 'Enter the value',
      ),
    );
  }

  TextFormField buildDueDayTextFormField() {
    return TextFormField(
      controller: _dueDay,
      keyboardType: TextInputType.number,
      maxLength: 2,
      validator: (value) {
        if (value.isEmpty) {
          return 'Due day is required';
        }
        if (int.parse(value) > 31 || int.parse(value) < 1) {
          return 'Invalid due day';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Due day *',
        hintText: 'Enter the due day',
      ),
    );
  }
}
