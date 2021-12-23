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
      // decoration: BoxDecoration(
      //   color: Colors.grey[500],
      // ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 5),
              height: 150,
              width: 150,
              child: Image.network(studentMockList[index].imgUrl ??
                  'https://bondprinting.com/wp-content/uploads/2019/03/placeholder-face-big.png')),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                    ),
                    Text(
                      studentMockList[index].name ?? 'no name',
                      style: TextStyle(fontSize: 14),
                    ),
                    Column(
                      children: [
                        Text(studentMockList[index].points.toString()),
                        Divider(
                          height: 8,
                        ),
                        Text('points'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
