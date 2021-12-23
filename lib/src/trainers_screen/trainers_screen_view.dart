import 'package:flutter/material.dart';
import 'package:wecode_2021/src/temp/students_mock_data.dart';

class TrainersScreenView extends StatelessWidget {
  const TrainersScreenView({Key? key, this.userName, this.password})
      : super(key: key);
  final String? userName;
  final String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: studentMockList.length,
        itemBuilder: (context, index) {
          return _theStudentsCard(index);
        },
      ),
    );
  }

  Widget _theStudentsCard(int index) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          )),
      child: Text(studentMockList[index].name ?? 'no name'),
    );
  }
}
