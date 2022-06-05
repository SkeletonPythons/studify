import 'package:get/get.dart';
import 'package:flutter/material.dart';
import'../../../services/auth.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
            children: <Widget>[
        Container(
        height: size.height * .3,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/dashboard_header.png'),
                    ),
                ),
            ),
              Column(
                children: <Widget>[
                  Container(
                    height:64,
                    child:Row(
                      children:<Widget>[
                        CircleAvatar(
                          onBackgroundImageError: (value,trace){},
                          backgroundImage: NetworkImage( Auth.instance.USER.photoUrl!),
                        )
                      ]
                    )
                  )
                ]
              )
            ]
        ),
      ),
    );
  }
}


