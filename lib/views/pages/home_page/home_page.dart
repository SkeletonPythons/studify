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
  HomeController homeController = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    if (Auth.instance.USER.photoUrl == null ||
        Auth.instance.USER.photoUrl == '') {
      homeController.photoUrl?.value = '';
    } else {
      homeController.photoUrl?.value = Auth.instance.USER.photoUrl!;
    }

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
          controller: homeController.tabController,
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
                  CircleAvatar(
                    onBackgroundImageError: (value, trace) {},
                    backgroundImage:
                        NetworkImage(homeController.photoUrl!.value),
                    radius: 32,
                    child: homeController.photoUrl!.value == ''
                        ? Text(
                            '${Auth.instance.USER.name.substring(0, 1).toUpperCase()}${Auth.instance.USER.name.split(' ')[1][0].toUpperCase()}') // <- this is the first letter of the first and last name
                        : null,
                  )
                ]))
          ])
        ]),
      ),
    );
  }
}
