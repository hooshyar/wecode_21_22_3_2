//todo to create a form
//todo to have multiple text inputs according to our data model
//todo update the data model to have isCompletedProfile as a boolean
//todo validate the form
//add data to firestore db /users/
//set data
// read the data and get an approve from the user
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/constants/style.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class CreateProfileScreen extends StatefulWidget {
  CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formGlobalKey = GlobalKey<FormState>(); // the form key

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _bootCampIdController = TextEditingController();

  final TextEditingController _bootCampNameController = TextEditingController();

  //todo we want to save the email address and the UID as well
  @override
  Widget build(BuildContext context) {
    var _authProvider = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create your profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        child: Form(
            key: _formGlobalKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: generalInputDecoration(labelText: 'name'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: generalInputDecoration(labelText: 'phone Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'the phone number is required';
                    } else
                      return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _bootCampNameController,
                  decoration:
                      generalInputDecoration(labelText: 'bootcamp name'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _bootCampIdController,
                  decoration: generalInputDecoration(labelText: 'bootcamp ID'),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () async {
                          bool _isValidated =
                              _formGlobalKey.currentState!.validate();

                          if (_isValidated == true) {
                            //make our job easier
                            GeneralUser _generalUser = GeneralUser(
                              uid: _authProvider.theUser!.uid,
                              email: _authProvider.theUser!.email,
                              name: _nameController.value.text,
                              phoneNumber: _phoneNumberController.value.text,
                              bootCampName: _bootCampNameController.value.text,
                              bootCampId: _bootCampIdController.value.text,
                            );

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(_authProvider.theUser!.uid)
                                .set(_generalUser.toMap(),
                                    SetOptions(merge: true));
                            //     .collection('users')
                            //     .add({
                            //   'name': "wha",
                            //   'email': 00121212,
                            //   'bootCampId': "whad",
                            // }).catchError((e) => debugPrint(e.toString()));
                          }
                        },
                        child: Text('Create it!'))),
                Text('Name: ' +
                    _nameController.value.text +
                    'bootCampId: ' +
                    'phone: ' +
                    _phoneNumberController.value.text),
                Divider(),
                Text('List of users using Futures:'),
                Container(
                  height: 80,
                  color: Colors.grey[300],
                  child: FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('users').get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('error');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('empty');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        List<DocumentSnapshot> _docs = snapshot.data!.docs;

                        List<GeneralUser> _users = _docs
                            .map((e) => GeneralUser.fromMap(
                                e.data() as Map<String, dynamic>))
                            .toList();

                        return ListView.builder(
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              return Text(_users[index].name ?? 'no name');
                            });
                      }
                      return LinearProgressIndicator();
                    },
                  ),
                ),
                Divider(),
                Text('List of users using Stream:'),
                Container(
                    height: 80,
                    color: Colors.amber[300],
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('error');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Text('empty');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LinearProgressIndicator();
                          }

                          List<DocumentSnapshot> _docs = snapshot.data!.docs;

                          List<GeneralUser> _users = _docs
                              .map((e) => GeneralUser.fromMap(
                                  e.data() as Map<String, dynamic>))
                              .toList();

                          return ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                return Text(_users[index].name ?? 'no name');
                              });
                        })),
              ],
            )),
      ),
    );
  }
}
