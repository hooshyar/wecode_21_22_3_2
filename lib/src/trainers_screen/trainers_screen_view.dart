import 'package:flutter/material.dart';

class TrainersScreenView extends StatelessWidget {
  const TrainersScreenView({Key? key, this.userName, this.password})
      : super(key: key);
  final String? userName;
  final String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('trainers screen $userName ')),
    );
  }
}
