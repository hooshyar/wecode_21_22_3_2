import 'package:flutter/material.dart';
import 'package:wecode_2021/src/constants/style.dart';


class job_screen extends StatefulWidget {
  const job_screen({ Key? key }) : super(key: key);

  @override
  _job_screenState createState() => _job_screenState();
}

class _job_screenState extends State<job_screen> {
  @override

  
  TextEditingController job_title_Controller = TextEditingController();
  TextEditingController category_Controller = TextEditingController();
  TextEditingController company_name_Controller = TextEditingController();
  TextEditingController job_desc_Controller = TextEditingController();
  TextEditingController hires_times_Controller = TextEditingController();
  TextEditingController salary_Controller = TextEditingController();
  TextEditingController date_valid_Controller = TextEditingController();
  TextEditingController send_cv_Controller = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        title: Text("Add a new job "),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),

      body: SingleChildScrollView(
        child: Container(
      
          child:  Form(
      
                child: Column(
                children: [
                 SizedBox(height: 15),
      
                  TextFormField(
                    controller: job_title_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'Job Title'),
                  ),
                  
                  SizedBox(height: 15),

                  TextFormField(
                    controller: category_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'Category', hintText: 'category'),
                  ),
                  SizedBox(height: 15),
      
                  TextFormField(
                    controller: company_name_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'Company name', hintText: 'Company name'),
                  ),
      
                  SizedBox(height: 15),
      
                  TextFormField(
                    controller: job_desc_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'Job desc', hintText: 'job desc'),
                  ),
      
                   SizedBox(height: 15),
      
      
                  TextFormField(
                    controller: hires_times_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'how many hires', hintText: 'how many hires'),
                  ),
      
                  SizedBox(height: 15),
      
      
                  TextFormField(
                    controller: salary_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'Salary estimation', hintText: 'Salary estimation'),
                  ),                
                  
                   SizedBox(height: 15),
      
      
                  TextFormField(
                    controller: date_valid_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'valid till date'),
                  ),
      
                  SizedBox(height: 15),
      
      
                  TextFormField(
                    controller: send_cv_Controller ,
                    keyboardType: TextInputType.text,
                    decoration: generalInputDecoration(
                        labelText: 'Send CV to email'),
                  ),

                  ElevatedButton(onPressed: (){}, child: Text("Add New Job"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)
                    
                     ),
                  )
                  
                
      
                ]
          ),
        ),

     ),
      ),
    );
  }
}