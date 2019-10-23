import 'package:inject/inject.dart';
import 'package:invoice_control/src/blocs/bloc_base.dart';
import 'package:invoice_control/src/models/invoice-result.dart';
import 'package:invoice_control/src/repositories/invoice-repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class InvoiceBloc extends BlocBase {
  final InvoiceRepository _repository;
  PublishSubject<InvoiceResult> _invoicesFetcher;

  @provide
  InvoiceBloc(this._repository);

  init() {
    _invoicesFetcher = PublishSubject<InvoiceResult>();
  }

  Observable<InvoiceResult> get allInvoices => _invoicesFetcher.stream;

  fetchAllInvoices() async {
    InvoiceResult invoiceResult = await _repository.fetchAllInvoices();
    _invoicesFetcher.sink.add(invoiceResult);
  }

  @override
  void dispose() {
    _invoicesFetcher.close();
  }
}
