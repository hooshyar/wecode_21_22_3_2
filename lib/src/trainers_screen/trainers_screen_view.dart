import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/student_screen/student_screen_view.dart';

class TrainersScreenView extends StatelessWidget {
  const TrainersScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    List<GeneralUser>? _allUsers = Provider.of<List<GeneralUser>?>(context);
    return _allUsers == null
        ? CircularProgressIndicator()
        : Scaffold(
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
              itemCount: _allUsers.length,
              itemBuilder: (contex, index) {
                return PersonCardWidget(theUser: _allUsers[index]);
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
    required this.theUser,
  }) : super(key: key);

  final GeneralUser theUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.black,
      elevation: 12,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentScreen(
                        generalUser: theUser,
                      )));
        },
        child: Container(
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 4),
              CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: NetworkImage(theUser.imgUrl ??
                    'https://researcher.almojam.org/api/assets/unknown.jpg'),
              ),
              Container(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      theUser.name ?? 'no name',
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
