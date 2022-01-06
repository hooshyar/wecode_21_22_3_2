//todo to create a form
//todo to have multiple text inputs according to our data model
//todo update the data model to have isCompletedProfile as a boolean
//todo validate the form
//add data to firestore db /users/
//set data
// read the data and get an approve from the user
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/constants/style.dart';

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
                            //todo write to the /users/ collection using add
                            //todo write to the /users/ collection using set
                            //the document ID has to be the users UID
                            await FirebaseFirestore.instance
                                .collection('users')
                                .add({
                              'name': "wha",
                              'email': 00121212,
                              'bootCampId': "whad",
                            }).catchError((e) => debugPrint(e.toString()));
                          } else {
                            debugPrint('=======>>>>>> not validated');
                          }
                          //to add/set record to the firestore
                          setState(() {});
                        },
                        child: Text('Create it!'))),
                Text('Name: ' +
                    _nameController.value.text +
                    'bootCampId: ' +
                    'phone: ' +
                    _phoneNumberController.value.text),
              ],
            )),
      ),
    );
  }
}
