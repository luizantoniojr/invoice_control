import 'package:inject/inject.dart';
import 'package:invoice_control/src/blocs/bloc_base.dart';
import 'package:invoice_control/src/models/invoice-result.dart';
import 'package:invoice_control/src/models/invoice.dart';
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

  fetchAll() async {
    InvoiceResult invoiceResult = await _repository.fetchAll();
    _invoicesFetcher.sink.add(invoiceResult);
    return invoiceResult;
  }

  update(Invoice invoice) {
    _repository.update(invoice);
  }

  updatePaymentDate(Invoice invoice, DateTime paymentDate) {
    if (!invoice.checkIfWasPayed(paymentDate))
      invoice.paymentDates.add(paymentDate);
    else
      invoice.removerPayment(paymentDate);
    this.update(invoice);
  }

  @override
  void dispose() {
    _invoicesFetcher.close();
  }
}
