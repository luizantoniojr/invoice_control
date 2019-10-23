import 'package:inject/inject.dart';
import 'package:invoice_control/src/blocs/bloc_base.dart';
import 'package:invoice_control/src/models/invoice.dart';
import 'package:invoice_control/src/repositories/invoice-repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class InvoiceBloc extends BlocBase {
  final InvoiceRepository _repository;
  PublishSubject<Invoice> _invoicesFetcher;

  @provide
  InvoiceBloc(this._repository);

  init() {
    _invoicesFetcher = PublishSubject<Invoice>();
  }

  Observable<Invoice> get allInvoices => _invoicesFetcher.stream;

  fetchAllInvoices() async {
    Invoice invoice = await _repository.fetchAllInvoices();
    _invoicesFetcher.sink.add(invoice);
  }

  @override
  void dispose() {
    _invoicesFetcher.close();
  }
}
