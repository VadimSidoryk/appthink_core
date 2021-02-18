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

          return UserDetailsWidget(state.value);
        });
  }
}

class UserDetailsWidget extends StatelessWidget {
  final UserDetailsModel _model;

  const UserDetailsWidget(this._model);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: 0.35,
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
                          )))
            ],
          ),
        ),
      ],
    );
  }
}
