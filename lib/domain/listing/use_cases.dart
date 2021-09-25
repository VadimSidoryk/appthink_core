import 'package:applithium_core/usecases/base.dart';

import 'model.dart';

class ListingUseCases<IM, M extends BaseListModel<IM>> {
  final UseCase<void, M> load;
  final UseCase<M, M> update;
  final UseCase<M, M> loadMore;

  ListingUseCases({required this.load, required this.update, required this.loadMore});
}