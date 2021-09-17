class ExampleListingScreen
    extends BaseWidget<List<ListItemModel>, ListingScreenState<ListItemModel>> {

  static int _scrollThreshold = 200;

  static Widget createWidgetForState(BuildContext context,
      ListingScreenState<ListItemModel> state, EventsListener handler) {
    if (state is ListLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is HasList<ListItemModel>) {
      final scrollController = ScrollController();
      scrollController.addListener(() {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        if (maxScroll - currentScroll <= _scrollThreshold) {
          handler.onNewEvent(ScrolledToEnd());
        }
      });
      final list = (state as HasList<ListItemModel>).list;
      return Scaffold(
          body: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) => ListTile(
                  title: Text(list[index].title),
                  subtitle: Text(list[index].subtitle))));
    } else {
      final error = state is ListLoadingFailed
          ? (state as ListLoadingFailed).error
          : "Undefined error";
      return Text("error $error");
    }
  }

  ExampleListingScreen() : super(createWidgetForState);

  @override
  DomainGraph<List<ListItemModel>, ListingScreenState<ListItemModel>> get domainGraph => listingGraph;

  @override
  ListingScreenState<ListItemModel> getInitialState() {
    return ListingScreenState.initial();
  }
}