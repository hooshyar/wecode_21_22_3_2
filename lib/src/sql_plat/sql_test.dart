import 'package:flutter/material.dart';
import 'package:wecode_2021/src/services/sql_service.dart';
import 'package:wecode_2021/src/sql_plat/sql_data_models.dart';

class SqlTestPage extends StatefulWidget {
  const SqlTestPage({Key? key}) : super(key: key);

  @override
  State<SqlTestPage> createState() => _SqlTestPageState();
}

class _SqlTestPageState extends State<SqlTestPage> {
  SqlDataBaseHelper _sqlDataBaseHelper = SqlDataBaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w200),
          ),
          Container(
            height: 300,
            child: FutureBuilder(
                future: _sqlDataBaseHelper.findAllRecipes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  }
                  return Text(snapshot.data.toString());
                }),
          ),
          ElevatedButton(
              onPressed: () {
                _sqlDataBaseHelper.insertRecipe(
                    Recipe(id: 3232, totalTime: "fdsa", totalWeight: "323"));
              },
              child: Text('data'))
        ],
      )),
    );
  }
}
