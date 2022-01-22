import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class TrainersScreenView extends StatelessWidget {
  const TrainersScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(
      appBar: AppBar(title: Text('Trainer Dashboard'), actions: [
        IconButton(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logOut();
            },
            icon: Icon(Icons.logout)),
      ]),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        // shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: 12,
        itemBuilder: (contex, index) {
          return PersonCardWidget();
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 5,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
        ),
      ),
    );
  }
}

class PersonCardWidget extends StatelessWidget {
  const PersonCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.black,
      elevation: 12,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 4),
              CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: NetworkImage(
                    'https://researcher.almojam.org/api/assets/unknown.jpg'),
              ),
              Container(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'student name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'the text',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
