import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/jobs_screen/jobs_board_screen.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/student_screen/news_student_screen.dart';
import 'package:wecode_2021/src/student_screen/student_dashboard_screen.dart';

class StudentLinktreeView extends StatefulWidget {
  const StudentLinktreeView({Key? key}) : super(key: key);

  @override
  _StudentLinktreeViewState createState() => _StudentLinktreeViewState();
}

class _StudentLinktreeViewState extends State<StudentLinktreeView> {
  @override
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController _searchController = TextEditingController();
  String? theSearch;
  String dropdownValue = 'date'; //bootcoamp name
  bool canSearch = false;

  @override
  void initState() {
    canSearch = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        label: Text('search'), hintText: 'name'),
                    onChanged: (value) {
                      if (value.length < 1) {
                        setState(() {
                          canSearch = false;
                          debugPrint(canSearch.toString());
                        });
                      } else {
                        setState(() {
                          canSearch = true;
                          debugPrint(canSearch.toString());
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: canSearch == true
                      ? whatShouldIDO
                      : null, //if cansearch true return something, else return null
                  icon: FaIcon(FontAwesomeIcons.search),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'sort by: ',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  width: 5,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['date', 'bootcamp name']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder<List<GeneralUser>>(
                stream: _firestoreService.streamOfGeneralUsers(
                    name: theSearch, sortby: dropdownValue),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PersonCardWidget(theUser: snapshot.data![index]);
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  whatShouldIDO() {
    setState(() {
      theSearch = _searchController.value.text;
    });
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
                  builder: (context) => NewsStudentScreen(
                        generalUser: theUser,
                      )));
        },
        child: Container(
          height: 90,
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 4),

              // CircleAvatar(
              //   radius: 70,
              //   backgroundColor: Theme.of(context).primaryColor,
              //   onBackgroundImageError: (err, stack) =>
              //       debugPrint(err.toString()),
              //   backgroundImage: NetworkImage(theUser.imgUrl ??
              //       'https://researcher.almojam.org/api/assets/unknown.jpg'),
              // ),

              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
