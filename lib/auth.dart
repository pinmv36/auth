import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Post> fetchAlbom() async {
  final response=await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode==200) {
    return Post.fromJson(jsonDecode(response.body
    ));
  } else {
    throw Exception('Failed to load album');
  }
}

class Post {
  final int userid;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userid,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }
}

class NetworkingScreen extends StatefulWidget{
  const NetworkingScreen({Key? key}): super(key: key);

  @override
  _NetworkingScreenState createState() =>_NetworkingScreenState();
}

class _NetworkingScreenState extends State<NetworkingScreen>{
  late Future<Post> futureAlbum;

  @override
  void initState(){
    super.initState();
    futureAlbum=fetchAlbom();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      //title: 'что-то',
      theme:ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: const Text ('Связь')
        ),
        body: Column(children: [
            SizedBox(height: 100.0,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: FutureBuilder<Post>(
              future: futureAlbum,
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Text (snapshot.data!.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontSize: 16.0));
                } else if (snapshot.hasError){
                  return Text ('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
          ),
            ),
          SizedBox(height: 100.0,),
        FutureBuilder<Post>(
          future: futureAlbum,
          builder: (context, snapshot){
            if (snapshot.hasData){
              return Text (snapshot.data!.body,
                  style: TextStyle(
                      fontSize: 14.0));
            } else if (snapshot.hasError){
              return Text ('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),]
        ),

      ),
    );
  }
}