import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainersScreenView extends StatelessWidget {
  const TrainersScreenView({Key? key, this.userName, this.password})
      : super(key: key);
  final String? userName;
  final String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trainer Dashboard'), actions: [
          IconButton(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logOut();
              },
              icon: Icon(Icons.logout)),
        ]),
        body: Container(
          child: FutureBuilder<List<dynamic>>(
            future: getUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                //  todo: show a loading widget
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // show an error
                return Text(snapshot.error.toString());
              } else {
                //show the data
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Text(snapshot.data![index]);
                    });
              }
            },
          ),
        )

        // ListView.builder(
        //   itemCount: studentMockList.length,
        //   itemBuilder: (context, index) {
        //     return _theStudentsCard(index);
        //   },
        // ),
        );
  }

  Future<List<dynamic>> getUsers() async {
    //the end point url
    String theUrl = "https://jsonplaceholder.typicode.com/users";

    // wait and revieve a response from the endpoint
    http.Response response = await http.get(Uri.parse(theUrl));

    // decode the json body to a list<dynamic>
    List decodedJson = jsonDecode(response.body);

    // return a list of strings from the list<dynamic> we had
    return decodedJson.map((e) => e["name"]).toList();
  }

  Widget _theStudentsCard(int index) {
    return Scaffold(
      body: Container(
        child: Text('the trainers screen'),
      ),
    );
    // return Container(
    //   padding: EdgeInsets.all(8),
    //   margin: EdgeInsets.only(top: 10, right: 10, left: 10),
    //   // decoration: BoxDecoration(
    //   //   color: Colors.grey[500],
    //   // ),
    //   child:
    //    Stack(
    //     children: [
    //       Positioned(
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: Container(
    //           height: 140,
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //               color: Colors.grey[300],
    //               borderRadius: BorderRadius.all(Radius.circular(8))),
    //         ),
    //       ),
    //       Container(
    //           margin: EdgeInsets.only(left: 5),
    //           height: 150,
    //           width: 150,
    //           child: Image.network(studentMockList[index].imgUrl ??
    //               'https://bondprinting.com/wp-content/uploads/2019/03/placeholder-face-big.png')),
    //       Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 SizedBox(
    //                   height: 150,
    //                   width: 90,
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(left: 10),
    //                   child: Text(studentMockList[index].name ?? 'no name',
    //                       textAlign: TextAlign.left,
    //                       style: GoogleFonts.roboto(fontSize: 18)),
    //                 ),
    //                 Column(
    //                   children: [
    //                     Container(
    //                       child: Text(
    //                         studentMockList[index].points.toString(),
    //                       ),
    //                     ),
    //                     Divider(
    //                       height: 8,
    //                     ),
    //                     Text('points'),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),

    // );
  }
}
