import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: AppBar(title: Text('AuthHandler'), actions: [
          IconButton(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logOut();
              },
              icon: Icon(Icons.logout)),
        ]),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(18),
                color: Colors.red,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        child: Image.network(_authService.generalUser!.imgUrl!),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        color: Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Status'),
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Eiusmod reprehenderit officia sunt cillum fugiat irure. Ad et sit ea est laboris et veniam deserunt sint in culpa qui reprehenderit. Officia consectetur excepteur duis aliqua quis excepteur pariatur elit culpa fugiat irure. Labore quis veniam ad cillum ',
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                // color: Colors.blue,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 18, right: 18),
                      height: 70,
                      child: ElevatedButton(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              FontAwesomeIcons.linkedin,
                              size: 32,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '${Provider.of<AuthService>(context).generalUser == null ? '' : Provider.of<AuthService>(context).generalUser!.name}\'s LinkedIn',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
