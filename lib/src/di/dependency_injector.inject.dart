import 'dependency_injector.dart' as _i1;
import 'main_module.dart' as _i2;
import '../externalServices/firebase-service.dart' as _i3;
import '../repositories/invoice-repository.dart' as _i4;
import 'dart:async' as _i5;
import '../app.dart' as _i6;
import '../blocs/invoices_bloc.dart' as _i7;

class DependencyInjector$Injector implements _i1.DependencyInjector {
  DependencyInjector$Injector._(this._mainModule);

  final _i2.MainModule _mainModule;

  _i3.FirebaseService _singletonFirebaseService;

  _i4.InvoiceRepository _singletonInvoiceRepository;

  static _i5.Future<_i1.DependencyInjector> create(
      _i2.MainModule mainModule) async {
    final injector = DependencyInjector$Injector._(mainModule);

    return injector;
  }

  _i6.App _createApp() => _i6.App(_createInvoiceBloc());
  _i7.InvoiceBloc _createInvoiceBloc() =>
      _i7.InvoiceBloc(_createInvoiceRepository());
  _i4.InvoiceRepository _createInvoiceRepository() =>
      _singletonInvoiceRepository ??=
          _mainModule.invoiceRepository(_createFirebaseService());
  _i3.FirebaseService _createFirebaseService() =>
      _singletonFirebaseService ??= _mainModule.firebaseService();
  @override
  _i6.App get app => _createApp();
}
