import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomUserPage(),
    );
  }
}

class RandomUserPage extends StatefulWidget {
  @override
  _RandomUserPageState createState() => _RandomUserPageState();
}

class _RandomUserPageState extends State<RandomUserPage> {
  late Future<User> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = fetchUser();
  }


  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body)['results'][0];
      User user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
      child:
      Container(
        child: FutureBuilder<User>(
          future: _futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
               Container(
                 height: size.height*0.3,
                 width: size.width*1,
                 child: Stack(
                   children: [
                     Positioned(
                       top: 0,
                       child: Container(
                         height: size.height*0.15,
                         width: size.width*1,
                         color: Colors.cyan[900],
                       ),
                     ),
                     Center(
                       child: CircleAvatar(
                           radius: 85.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                         radius: 80.0,
                         backgroundImage: NetworkImage(snapshot.data!.picture.large),
                       )
                       )
                     ),
                   ],
                 ),
               ),
                SizedBox(height: 16.0),
                      Divider(),

                      Text(
                  '${snapshot.data!.name.title} ${snapshot.data!.name.first} ${snapshot.data!.name.last}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(
                              Icons.email_outlined,
                              color: Colors.pink,
                              size: 24.0,
                            ),
                            Text(
                              ' '+snapshot.data!.email,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ]
                      ),
                SizedBox(height: 16.0),
                Divider(),
                SizedBox(height: 16.0),
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Age: ${snapshot.data!.age}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Gender: ${snapshot.data!.gender}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Divider(),
                SizedBox(height: 16.0),
                Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(
                              Icons.phone_android_outlined,
                              color: Colors.pink,
                              size: 24.0,
                            ),
                            Text(
                              ' Phone: ${snapshot.data!.phone}',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ]
                      ),

                SizedBox(height: 8.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(
                              Icons.call_outlined,
                              color: Colors.pink,
                              size: 24.0,
                            ),
                            Text(
                              ' Cell: ${snapshot.data!.cell}',
                              style:TextStyle(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ]
                      ),

            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.pink,
                              size: 24.0,
                            ),
                            Text(
                              'Location ',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          ]
                      ),

            SizedBox(height: 8.0),
            Text(
            '${snapshot.data!.location.street.number} ${snapshot.data!.location.street.name}',
            style: TextStyle(
            fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
            '${snapshot.data!.location.city}, ${snapshot.data!.location.state} ${snapshot.data!.location.postcode}',
            style: TextStyle(
            fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
            '${snapshot.data!.location.country}',
            style: TextStyle(
            fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
            ),
            ],
            ),
            );
            } else if (snapshot.hasError) {
             fetchUser();
            return Text("Someting wrong try again!");
            }

            // By default, show a loading spinner.
            return Container(
              height: size.height*1,
              child:Center(
             child: CircularProgressIndicator(),
              )
            );

          },
        ),
      ),
      )
    );
  }
}

class User {
  final Name name;
  final String email;
  final String phone;
  final String cell;
  final String gender;
  final int age;
  final Picture picture;
  final Location location;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.cell,
    required this.gender,
    required this.age,
    required this.picture,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: Name.fromJson(json['name']),
      email: json['email'],
      phone: json['phone'],
      cell: json['cell'],
      gender: json['gender'],
      age: json['dob']['age'],
      picture: Picture.fromJson(json['picture']),
      location: Location.fromJson(json['location']),
    );
  }
}
class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'],
      first: json['first'],
      last: json['last'],
    );
  }
}
class Picture {
  final String large;

  Picture({required this.large});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      large: json['large'],
    );
  }
}

class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  var postcode;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: Street.fromJson(json['street']),
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode'],
    );
  }
}

class Street {
  final int number;
  final String name;

  Street({required this.number, required this.name});

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(
      number: json['number'],
      name: json['name'],
    );
  }
}