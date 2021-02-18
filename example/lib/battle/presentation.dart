import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  const _BattleDetailsWidget(this._model, this._voteForParticipant1, this._voteForDraft, this._voteForParticipant2);

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
      children: [
        _createHeaderBackground(),
        _createHeaderContent()
      ],
    );
  }

  Widget _createHeaderBackground() {
    return Row(
      children: <Widget>[
        Flexible(
          child: CachedNetworkImage(
              imageUrl: _model.participant1.fullSizeImage,
              imageBuilder: (context, imageProvider) => Container(
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
              imageBuilder: (context, imageProvider) => Container(
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
    return Align(child: Row(
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
    ), alignment: Alignment.bottomCenter,);
  }

  Widget _createContentWidget() {}
}
