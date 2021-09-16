import 'package:applithium_core/usecases/base.dart';

import 'model.dart';

class ListingUseCases<IM, M extends WithList<IM>> {
  final UseCase<void, M> load;
  final UseCase<M, M> loadMore;

  ListingUseCases({required this.load, required this.loadMore});
}