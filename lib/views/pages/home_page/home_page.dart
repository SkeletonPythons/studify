import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller = TabController(length: 4, vsync: this);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color(0xff414141),
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width,
        child: TabBar(
          tabs: <Widget>[
            Container(child: Icon(Icons.home)),
            Container(child: Icon(Icons.flash_on)),
            Container(),
            Container()
          ],
          controller: controller,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: <Widget>[
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
          Column(children: <Widget>[
            Container(
                height: 64,
                child: Row(children: <Widget>[
                  // CircleAvatar(
                  //   onBackgroundImageError: (value, trace) {},
                  //   backgroundImage: NetworkImage(Auth.instance.USER.photoUrl!),
                  // )
                ]))
          ])
        ]),
      ),
    );
  }
}
