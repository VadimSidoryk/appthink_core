import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped/scoped.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage();

  @override
  State<StatefulWidget> createState() {
    return _UserDetailsState();
  }
}

class _UserDetailsState extends State<UserDetailsPage> {
  UserDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = UserDetailsBloc(context.get());
    return BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, ContentState<UserDetailsModel> state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.error != null) {
            return Center(
              child: Text('failed to fetch battles'),
            );
          }

          return UserDetailsWidget(
              state.value, () => _bloc.add(UserDetailsEvent.increaseBalance()));
        });
  }
}

class UserDetailsWidget extends StatelessWidget {
  final UserDetailsModel _model;
  final Function() _onClickListener;

  const UserDetailsWidget(this._model, this._onClickListener);

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Colors.black12),child: Stack(
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.41,
              child: Stack(
                children: [
                  CachedNetworkImage(
                      imageUrl: _model.backgroundUrl,
                      imageBuilder: (context, imageProvider) => Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill)),
                          )),
                  Align(
                      alignment: Alignment.center,
                      child: _createDetailsWidget())
                ],
              ),
            )),
        Align(
          child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.61,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox.expand(
                      child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16), topRight: Radius.circular(16))))))),
          alignment: Alignment.bottomCenter,
        )
      ],
    ));
  }

  Widget _createDetailsWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(5),
            child: CachedNetworkImage(
                imageUrl: _model.thumbnailUrl,
                imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ))),
        Padding(
            child: Text(_model.displayName,
                style: TextStyle(fontSize: 12, color: Colors.white)),
            padding: EdgeInsets.all(5)),
        Padding(
            child: Text("${_model.balance} \$",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            padding: EdgeInsets.all(5)),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: SizedBox(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      color: Colors.black,
                      child: Text(
                        "Пополнить Баланс",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _onClickListener.call(),
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
                        child: Text("Вывод средств",
                            style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                      )),
                  width: double.infinity,
                ),
                flex: 1),
          ],
        )
      ],
    );
  }
}
