import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/base_repository.dart';
import 'package:applithium_core/presentation/base_builder.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'repository.dart';

class ListingPresentationBuilder<T> extends AplPresentationBuilder<List<T>, ListingRepository<T>> {
  @override
  BlocFactory createBlocFactory(
      ListingRepository<T> repository,
      Map<String, UseCase<List<T>>> domain) {
    return (context) => ListingBloc(
        repository: repository,
        domain: domain);
  }

  @override
  ListingRepository<T> createRepository(
      Map<String, UseCase<List<T>>> domain, int ttl) {
    return ListingRepository(
        domain[EVENT_UPDATE_REQUESTED_NAME]!,
        ttl: ttl);
  }
}
