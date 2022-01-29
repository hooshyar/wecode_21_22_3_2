import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/constants/config.dart';
import 'package:wecode_2021/src/constants/style.dart';

import 'package:wecode_2021/src/data_models/job_model.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/widgets/jobs_card_widget.dart';

class NewJobScreen extends StatefulWidget {
  const NewJobScreen({Key? key}) : super(key: key);

  @override
  _NewJobScreenState createState() => _NewJobScreenState();
}

class _NewJobScreenState extends State<NewJobScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  TextEditingController job_title_Controller = TextEditingController();
  TextEditingController category_Controller = TextEditingController();
  TextEditingController company_name_Controller = TextEditingController();
  TextEditingController job_desc_Controller = TextEditingController();
  TextEditingController hires_times_Controller = TextEditingController();
  TextEditingController salary_Controller = TextEditingController();
  TextEditingController date_valid_Controller = TextEditingController();
  TextEditingController send_cv_Controller = TextEditingController();

  

  DateTime date = DateTime(2022,1,28);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new job "),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            child: Column(children: [
              SizedBox(height: 15),

              TextFormField(            
                controller: job_title_Controller,
                keyboardType: TextInputType.text,
                decoration: generalInputDecoration(labelText: 'Job Title'),
              ),

              SizedBox(height: 15),

              DropdownButtonFormField(
                decoration:generalInputDecoration(labelText: 'category'),
                items:jobCategories.map((e) =>DropdownMenuItem(
               value: e, 
               child: Text(e),
               )
               ).toList() ,
                onChanged:(value){setState(() { } 
                ); } 
                ),

              SizedBox(height: 15),

              TextFormField(
                controller: company_name_Controller,
                keyboardType: TextInputType.text,
                decoration: generalInputDecoration(
                    labelText: 'Company name',
                     hintText: 'Company name'),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: job_desc_Controller,
                keyboardType: TextInputType.text,
                decoration: generalInputDecoration(
                labelText: 'Job desc',
                 hintText: 'job desc'),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: hires_times_Controller,
                keyboardType: TextInputType.text,
                decoration: generalInputDecoration(
                    labelText: 'how many hires',
                     hintText: 'how many hires'),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: salary_Controller,
                keyboardType: TextInputType.text,
                decoration: generalInputDecoration(
                    labelText: 'Salary estimation',
                    hintText: 'Salary estimation'),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: date_valid_Controller,
                keyboardType: TextInputType.text,
                decoration:
                   InputDecoration(
                     icon: Icon(Icons.event), 
                     label: Text("valid till date"),
                      hintText: 'valid till date',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                   
                     ),
                     onTap: () async{

                   DateTime? newDAte= await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2040),
                    );
                    date_valid_Controller.text = date.toIso8601String();

                   },
                 ),

              SizedBox(height: 15),
              
              TextFormField(
                controller: send_cv_Controller,
                keyboardType: TextInputType.text,
                decoration:
               generalInputDecoration(
                 labelText: 'Send CV to email'
                 ),
              ),


              ElevatedButton(
                onPressed: () async {
                  Job _newJob = Job(
                      jobCategory: category_Controller.value.text,
                      jobCreatedAt: Timestamp.now(),
                      jobDueDate: Timestamp.now(),
                      jobDesc: job_desc_Controller.value.text,
                      jobViews: 0,
                      jobHiresCount: 0,
                      jobLikeCount: 0,
                      jobTitle: job_title_Controller.value.text,
                      companyName: 'some com',
                      emailAddress: 'fdsa',
                      salaryEstimate: 21212,
                      isFaved: false);

                  await _firestoreService
                      .addNewJob(_newJob)
                      .then((value) => Navigator.pop(context));
                },
                child: Text("Add New Job"),
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)
                
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
