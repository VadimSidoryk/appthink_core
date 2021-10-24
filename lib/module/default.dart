import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core/services/promo/service.dart';
import 'package:applithium_core/services/service_base.dart';

class DefaultModule extends AplModule {
  final Set<AplService> _services;

  DefaultModule({Set<AplService>? services})
      : _services = services ??
            {AnalyticsService(), PromoService(), UsageHistoryService()};

  @override
  Future<bool> injectConfigProvider(Store store) async {
    return false;
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    await Future.wait(_services.map((service) => service.init(config)));
    _services.forEach((service) {
      service.addToStore(store);
    });
  }
}
