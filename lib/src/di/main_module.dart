import 'package:inject/inject.dart';
import 'package:invoice_control/src/blocs/bloc_base.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/externalServices/firebase-service.dart';
import 'package:invoice_control/src/repositories/invoice-repository.dart';

@module
class MainModule {
  @provide
  @singleton
  FirebaseService firebaseService() => FirebaseService();

  @provide
  @singleton
  InvoiceRepository invoiceRepository(FirebaseService firebaseService) =>
      InvoiceRepository(firebaseService);

  @provide
  BlocBase invoiceBloc(InvoiceRepository repository) => InvoiceBloc(repository);
}
