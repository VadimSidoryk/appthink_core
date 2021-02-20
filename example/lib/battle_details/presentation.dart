import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'domain.dart';

class BattleDetailsScreen extends StatefulWidget {
  static const routeName = "/battle_details";

  @override
  State<StatefulWidget> createState() {
    return _BattleDetailsScreenState();
  }
}

class _BattleDetailsScreenState extends State<BattleDetailsScreen> {
  BattleDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BattleDetailsBloc(context.get());
    return Scaffold(
        body: BlocBuilder(
            cubit: _bloc,
            // ignore: missing_return
            builder:
                (BuildContext context, ContentState<BattleDetailsModel> state) {
              if (state.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.error != null) {
                return Center(
                  child: Text('failed to fetch battle details'),
                );
              }
              return _BattleDetailsWidget(
                state.value,
                    () => _bloc.add(BattleDetailsEvents.participant1Clicked()),
                    () => _bloc.add(BattleDetailsEvents.drawClicked()),
                    () => _bloc.add(BattleDetailsEvents.participant2Clicked()),
              );
            }));
  }
}

class _BattleDetailsWidget extends StatelessWidget {
  final BattleDetailsModel _model;
  final Function() _voteForParticipant1;
  final Function() _voteForDraft;
  final Function() _voteForParticipant2;

  _BattleDetailsWidget(this._model, this._voteForParticipant1,
      this._voteForDraft, this._voteForParticipant2);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.black12),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                    heightFactor: 0.41, child: _createHeaderWidget())),
            Align(
              child: FractionallySizedBox(
                  heightFactor: 0.61,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox.expand(
                          child: Container(
                              child: _createContentWidget(),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))))))),
              alignment: Alignment.bottomCenter,
            )
          ],
        ));
  }

  Widget _createHeaderWidget() {
    return Stack(
      children: [_createHeaderBackground(), _createHeaderContent()],
    );
  }

  Widget _createHeaderBackground() {
    return Row(
      children: <Widget>[
        Flexible(
          child: CachedNetworkImage(
              imageUrl: _model.participant1.fullSizeImage,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fitHeight)),
                  )),
          flex: 1,
        ),
        Flexible(
          child: CachedNetworkImage(
              imageUrl: _model.participant2.fullSizeImage,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fitHeight)),
                  )),
          flex: 1,
        )
      ],
    );
  }

  Widget _createHeaderContent() {
    return Column(children: [
      Flexible(
          flex: 1,
          child: Stack(children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(_model.participant1.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30))),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(_model.participant2.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)))
          ])),
      Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: SizedBox(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        color: Colors.blueAccent,
                        child: Text(
                          "${_model.participant1.name}",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _voteForParticipant1.call(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blueAccent)),
                      )),
                  width: double.infinity,
                ),
                flex: 1,
              ),
              Flexible(
                  child: SizedBox(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text("Ничья",
                              style: TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          onPressed: () => _voteForDraft.call(),
                        )),
                    width: double.infinity,
                  ),
                  flex: 1),
              Flexible(
                child: SizedBox(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        color: Colors.redAccent,
                        child: Text(
                          "${_model.participant2.name}",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _voteForParticipant2.call(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.redAccent)),
                      )),
                  width: double.infinity,
                ),
                flex: 1,
              ),
            ],
          )),
    ]);
  }

  Widget _createContentWidget() {
    return _MessagesWidget();
  }
}

class _MessagesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageWidgetState();
  }
}

class _MessageWidgetState extends State<_MessagesWidget> {
  MessagesListBloc _bloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _MessageWidgetState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = MessagesListBloc(context.get());
    return BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, ListState<BaseMessageItemModel> state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.error != null) {
            return Center(
              child: Text('failed to fetch messages'),
            );
          }

          if (state.value.isEmpty) {
            return Center(
              child: Text('no messages'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.value.length
                  ? BottomLoader()
                  : (state.value[index] is MessageItemModel)
                  ? MessageWidget(state.value[index])
                  : MessageWithBetWidget(state.value[index], (result) {
                _bloc.add(PersonalBetClicked(state.value[index], result));
              });
            },
            itemCount: state.isEndReached
                ? state.value.length
                : state.value.length + 1,
            controller: _scrollController,
          );
        });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.add(ScrolledToEnd());
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

class MessageWithBetWidget extends MessageWidget {

  static Color getBackgroundColor(MessageWithBetItemModel model) {
    return model.bet.result == BattleResult.PARTICIPANT_1_WIN
        ? Colors.blueAccent
        : Colors.redAccent;
  }

  static Widget Function(BuildContext) getHeaderBuilder(
      MessageWithBetItemModel model) =>
          (BuildContext context) {
        return Text("${model.bet.cashAmount} \$", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: model.bet.result == BattleResult.PARTICIPANT_1_WIN ? Colors
                .blueAccent : Colors.redAccent),);
      };

  static Widget Function(BuildContext) getFooterBuilder(
      MessageWithBetItemModel model,
      Function(BattleResult) footerClickListener) =>
          (BuildContext context) {
        List<Tuple3> data;

        if (model.bet.result == BattleResult.PARTICIPANT_1_WIN) {
          data = [
            Tuple3(Colors.blueAccent, model.bet.agreed, () =>
                footerClickListener.call(BattleResult.PARTICIPANT_1_WIN)),
            Tuple3(Colors.redAccent, model.bet.disagreed, () =>
                footerClickListener.call(BattleResult.PARTICIPANT_2_WIN))
          ];
        } else {
          data = [
            Tuple3(Colors.redAccent, model.bet.agreed, () =>
                footerClickListener.call(BattleResult.PARTICIPANT_2_WIN)),
            Tuple3(Colors.blueAccent, model.bet.disagreed, () =>
                footerClickListener.call(BattleResult.PARTICIPANT_1_WIN))
          ];
        }

        return Row(
          children: [
            ActionWidget(data[0].item1, data[0].item2, data[0].item3),
            Container(
              width: 5,
            ),
            ActionWidget(data[1].item1, data[1].item2, data[1].item3),
          ],
        );
      };

  final MessageWithBetItemModel _model;

  MessageWithBetWidget(this._model, Function(BattleResult) clickListener)
      : super(_model,
      backgroundColor: getBackgroundColor(_model),
      headerBuilder: getHeaderBuilder(_model),
      footerBuilder: getFooterBuilder(_model, clickListener));
}

class MessageWidget extends StatelessWidget {
  final BaseMessageItemModel _model;
  final timeFormat = DateFormat('hh:mm');

  Color backgroundColor = Colors.black12;
  Color messageColor = Colors.black;
  Widget Function(BuildContext) headerBuilder;
  Widget Function(BuildContext) footerBuilder;

  MessageWidget(this._model,
      {Color backgroundColor,
        Widget Function(BuildContext) headerBuilder,
        Widget Function(BuildContext) footerBuilder}) {
    if (backgroundColor != null) {
      this.backgroundColor = backgroundColor;
      this.messageColor = Colors.white;
    }

    this.headerBuilder = headerBuilder;
    this.footerBuilder = footerBuilder;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
                padding: EdgeInsets.only(right: 5),
                child: CachedNetworkImage(
                  imageUrl: _model.user.thumbnail,
                  imageBuilder: (context, imageProvider) =>
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_model.user.name),
                    headerBuilder != null ? headerBuilder.call(context) : Container(),
                    Container(
                      child: Text(
                        _model.message,
                        style: TextStyle(color: messageColor),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(10, 20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: backgroundColor),
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 10, right: 10),
                    ),
                    Align(
                      child: Text(
                          "${timeFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  _model.timeSend))}"),
                      alignment: Alignment.centerRight,
                    ),
                    footerBuilder != null
                        ? footerBuilder.call(context)
                        : Container()
                  ],
                ),
                flex: 1)
          ],
        ));
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class ActionWidget extends StatelessWidget {
  final Color _color;
  final int _count;
  final Function() _clickListener;

  const ActionWidget(this._color, this._count, this._clickListener);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            child: Padding(
                padding: EdgeInsets.all(3),
                child: Row(children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration:
                    BoxDecoration(shape: BoxShape.circle, color: _color),
                  ),
                  Container(width: 5),
                  Text("$_count",
                      style: TextStyle(
                          color: _color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ])),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black12)),
        onTap: _clickListener);
  }
}
