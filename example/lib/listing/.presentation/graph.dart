final DomainGraph<>
createListingGraph(listLoader, loadMore).plus((state, event) {
  if (event is ListingScreenEvents) {
    return event.fold(
            (removeItem) => DomainGraphEdge(
            sideEffect: SideEffect.change(removeItemsById(removeItem.id))),
            (addItem) => DomainGraphEdge());
  }
});