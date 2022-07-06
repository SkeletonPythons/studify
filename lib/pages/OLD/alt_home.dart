// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../utils/consts/app_colors.dart';
// import './alt_home_controller.dart';
// import '../../../services/auth.dart';
// import '../../../routes/routes.dart';

// class AltHome extends StatelessWidget {
//   const AltHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AltHomeController>(
//       init: Get.put(AltHomeController()),
//       initState: (_) {},
//       builder: (_) {
//         return SafeArea(
//           child: Scaffold(
//             key: _.altScaffoldKey,
//             backgroundColor: kBackgroundDark,
//             floatingActionButton: _.fabs[_.currentIndex.value],
//             appBar: PreferredSize(
//                 preferredSize: Size.fromHeight(60.0),
//                 child: AltAppBar(
//                     onSideMenuTap: () =>
//                         _.altScaffoldKey.currentState!.openDrawer())),
//             drawer: AltDrawer(),
//             body: TabBarView(
//               controller: _.tabController,
//               children: _.tabViews,
//             ),
//             bottomNavigationBar: Material(
//               color: kBackgroundLight,
//               child: TabBar(
//                 unselectedLabelStyle: GoogleFonts.ubuntu(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: kAccent,
//                 ),
//                 automaticIndicatorColorAdjustment: false,
//                 enableFeedback: true,
//                 labelStyle: GoogleFonts.ubuntu(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: kAccent,
//                 ),
//                 onTap: (newIndex) {
//                   _.currentIndex.value = newIndex;
//                 },
//                 controller: _.tabController,
//                 tabs: _.tabs,
//                 indicatorColor: kAccent,
//                 labelColor: kBackgroundLight2,
//                 unselectedLabelColor: kBackgroundLight,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class AltAppBar extends StatelessWidget {
//   const AltAppBar({
//     Key? key,
//     required this.onSideMenuTap,
//   }) : super(key: key);

//   final VoidCallback onSideMenuTap;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: kBackgroundLight2,
//       elevation: 0,
//       leading: IconButton(
//         icon: Icon(
//           Icons.menu,
//           color: kAccent,
//         ),
//         onPressed: onSideMenuTap,
//       ),
//     );
//   }
// }

// class AltDrawer extends StatelessWidget {
//   const AltDrawer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.redAccent,
//             ),
//             child: CircleAvatar(
//               maxRadius: 50,
//               onBackgroundImageError: (value, trace) {},
//               backgroundImage: Auth.instance.USER.photoUrl == ''
//                   ? AssetImage('assets/images/user.png')
//                   : NetworkImage(Auth.instance.USER.photoUrl!, scale: .25)
//                       as ImageProvider,
//             ),
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.developer_mode_sharp,
//             ),
//             title: Text('OG PAGES'),
//             onTap: () => Get.offAllNamed(Routes.NAVBAR),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AltDashboard extends StatelessWidget {
//   const AltDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: SizedBox(
//       height: Get.height * 0.5,
//       width: Get.width,
//       child: RichText(
//           text: TextSpan(
//         children: [
//           TextSpan(
//             text:
//                 '''Welcome to the Alternate Reality homepage.  This is just a demonstration of the
// homepage implemented using a tabview. I also threw in some extra functionality such as
// a floating action button that changes depending on the tab you are on.\n\n''',
//             style: GoogleFonts.architectsDaughter(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.orangeAccent,
//             ),
//           ),
//           TextSpan(
//             text: 'NOTE: ',
//             style: GoogleFonts.robotoCondensed(
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//               color: kAccent,
//             ),
//           ),
//           TextSpan(
//             text:
//                 '''Some of your code may or may not function as intended. This is just a demo. 
// Open the drawer to get back to the OG homepage by clicking the menu icon or dragging from left to right.''',
//             style: GoogleFonts.architectsDaughter(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.orangeAccent,
//             ),
//           ),
//         ],
//         style: GoogleFonts.architectsDaughter(
//             fontSize: 18, color: Colors.amberAccent),
//       )),
//     ));
//   }
// }
