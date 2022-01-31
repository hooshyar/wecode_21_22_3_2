import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        backgroundColor: Colors.deepPurple[400],
        centerTitle: true,

        actions: [
          IconButton(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      // backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return UserQuastionCard();
          },
        ),
      ),
    );
  }
}

class UserQuastionCard extends StatelessWidget {
  const UserQuastionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              width: 333,
              height: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'the user Name ask how to learn a BLoC liberay with flutter?the user Name ask how to learn a BLoC liberay with flutter?the user Name ask how to learn a BLoC liberay with flutter?the user Name ask how to learn a BLoC liberay with flutter  ?the user Name ask how to learn a BLoC liberay with flutter',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '2022/1/22  12:30 pm ',
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        Spacer(),
                        Text(
                          'Delman Ali ',
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 43,
          left: 10,
          child: CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(
                'https://researcher.almojam.org/api/assets/unknown.jpg'),
          ),
        ),
      ],
    );
  }
}
