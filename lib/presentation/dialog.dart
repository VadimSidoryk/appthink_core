import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:flutter/widgets.dart';

abstract class AplDialog<VM, O> extends StatefulWidget {
  final VM viewModel;
  final Function(VM, bool, O) resultListener;

  AplDialog(this.viewModel, this.resultListener);
}