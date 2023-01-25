import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  
  bool isLoaded = true;
  late var value;
  late int quotes_length;
  var client = http.Client();
  var quotes = [];


  @override
  void initState() {
    get_quotes();
    random();
    super.initState();
  }  


  @override
  Future<List> get_quotes() async {
    var url = Uri.https("type.fit", "/api/quotes");
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          quotes.add(data[i]);
        }
      }
    }
    quotes_length = quotes.length;
    setState(() {
      isLoaded = false;
    });
    return quotes;
  }

  int random() {
    setState(() {
      value = 0 + Random().nextInt(1643 - 0);
    });
    print(value);
    return value;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Dynamic Quotes")),
      ),
      body: isLoaded
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset('assets/quoteslogo.png', height: 60, width: 80,)), 
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '" ${quotes[value]["text"]} "',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        child: Text(quotes[value]["author"] == null ? "Anonymous" : quotes[value]["author"],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        random();
                      },
                      
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      color: Colors.blue,
                      child: Text(
                        "New Quote",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
