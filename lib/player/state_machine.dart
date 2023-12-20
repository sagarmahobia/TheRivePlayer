import 'package:rive/rive.dart';

class TheStateMachine {
  final String name;
  final StateMachine machine;

  TheStateMachine({required this.name, required this.machine});


  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}
