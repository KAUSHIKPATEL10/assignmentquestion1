import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<poke>> GetJson() async{
    Uri url= Uri.parse("https://dummyapi.online/api/pokemon");
    var data=await http.get(url);

    var JsonData = json.decode(data.body);
    List<poke> items =[];
    for (var pa in JsonData){
      poke p = poke(pa["pokemon"],pa["type"],pa["image_url"]);
      items.add(p);


    }
    return items;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: GetJson(),
            builder: (BuildContext context ,AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                      child: Text("Loading.....")
                  ),
                );
              }
              else{

                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context ,int index){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data[index].image_url),

                        ),
                        title: Text(snapshot.data[index].pokemon),
                        subtitle: Text(snapshot.data[index].type),

                      );
                    });
              }
            }
        ),




      ),
    );

  }
}
class poke {
  String pokemon;
  String type;
  String image_url;
  poke(this.pokemon,this.type,this.image_url);
}

