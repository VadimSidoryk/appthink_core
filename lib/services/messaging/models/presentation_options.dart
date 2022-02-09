import 'package:equatable/equatable.dart';

class MessagingOptions extends Equatable {
  final bool alert;
  final bool badge;
  final bool sound;

  const MessagingOptions({this.alert = true, this.badge = true, this.sound = true});

  @override
  List<Object?> get props => [alert, badge, sound];
}