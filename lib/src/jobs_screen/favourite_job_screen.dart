import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'add_new_job_screen.dart';

class FavouriteJobScreen extends StatefulWidget {
  const FavouriteJobScreen({ Key? key }) : super(key: key);

  @override
  _FavouriteJobScreenState createState() => _FavouriteJobScreenState();
}

class _FavouriteJobScreenState extends State<FavouriteJobScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Favs"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      
         floatingActionButton: FloatingActionButton(
           backgroundColor:Colors.black,
         child: Icon( FontAwesomeIcons.plus),
         onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewJobScreen()),
              )),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Fav',
            backgroundColor: Colors.green,
          ),
         
          
        ],
       
      ),
    );
  }
}

