import 'package:flutter/material.dart';

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
      
    );
  }
}