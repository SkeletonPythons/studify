/// These are imports of the various libraries and packages that we are using
/// for this file ONLY. Libraries that we did not create will use 'package:'.
/// in order to import them. The libraries must be listed in the [pubspec.yaml]
/// file under the [dependencies] section. [pubspec.yaml] is a file that
/// contains all the information about the project. It is very picky about spacing, so
/// be careful when editing it.
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// This warning is just saying that we did not use anything from this library in
/// this file. It won't have an effect on building the project, but it's good to
/// get rid of them as soon as possible if you're not going to use them.
import 'package:flutter/material.dart';

/// These imports are for the libraries that we created. They will use a relative
/// path to import them. (reletive to the file that we are in). [..] means go up one
/// directory. [.] means go to the current directory.
import '../../../consts/app_colors.dart';
import '../../../routes/routes.dart';
import '../../../controllers/login_controller.dart';
import'../../../services/auth.dart';
class LoginPage extends StatelessWidget {
  /// This class extends [StatelessWidget] which is a base class for widgets that
  /// do not maintain state. As stateless widgets, they are immutable.

  LoginPage({Key? key}) : super(key: key);

  /// This is the constructor for the [LoginPage] class. It takes one optional
  /// parameter, [key], which is a [Key] that can be used to identify the widget.
  /// The [key] parameter is optional and named meaning that if you want to call it
  /// with a value it would be like this:
  ///
  /// ```dart
  /// void main() {
  ///   RunApp( <--- This is the root widget of the app hypothetically
  ///     LoginPage( <--- This is the widget that we want to create
  ///       key: Key('login-page'), <--- This is the key that we want to use
  ///     ); <--- This is the end of the widget that we want to create
  ///   ); <--- This is the end of the root widget of the app
  /// } <--- This is the end of the main function
  /// ```
  /// the keyword [super] is used to call the parent class's constructor(in this case).
  /// [super] is always used to access the parent object in dart.

  /// Dart does not use private variables in the same sense as c# or java where they can't be
  /// accessed from outside the class. Instead, they can be seen by the entire file instead.
  /// As long as you keep one class per file, you can use private variables in the same way
  /// that you are used to. They will always have the [_] in front of them.
  final LoginController _controller = Get.put(LoginController());

  /// This is the [LoginController] that we will use to control the state of the
  /// [LoginPage] class. It is a [Get] variable that is used to store the
  /// any logic and observerables that we want to use in the [LoginPage] class.
  /// THIS IS NOT A REQUIREMENT TO USE. I just like to use it to make it easier to
  /// separate the logic from the UI and it also makes stateless widgets act like stateful ones

  /// All types of class [Widget] must have a [build] method. This is the method that
  /// is called when the widget is built. It is what you will see on the screen.
  /// [Widget] is abstract and has no body. It is a base class for all widgets.
  /// [StatelessWidget] is a class that extends [Widget] and has no state.
  /// [StatefulWidget] is a class that extends [Widget] and has state.
  /// [StatelessWidget] and [StatefulWidget] are the only two types of widgets that
  /// can be used in the [build] method. It must always be overridden.
  ///
  /// BuildContext is a class that is used to store information about the context
  /// in which the widget is being built. It is used to access the [BuildContext]
  /// of the parent widget. Many times you wont have to worry about it. We just call it
  /// [context] and it is a parameter of the [build] method.
  @override
  Widget build(BuildContext context) {
    /// The [build] method returns a [Widget]. It can also do other things before
    /// returning the [Widget], and can even use a conditional operator to combine
    /// multiple [Widget]s. For example, if you want to check if the user is logged in
    /// and then show a different [Widget] depending on that, you can do something like this:
    /// ```dart
    /// ... bool isLoggedIn = false;
    ///
    /// @override
    /// widget build(BuildContext context) {
    ///  return isLoggedIn? HomePage() : LoginPage();
    /// }
    /// ```
    ///
    return SignInScreen(
      headerBuilder: (context, constraints, shrinkOffset) {
        return Container(
          /// This is the [Container] widget that is probably the most common widget
          /// in Flutter. It is used to create a container that can be styled.
          /// you can press [ctrl + space] to see all the parameters that you can use
          /// in this section of the widget.
          ///
          /// Flutter has A LOT of built in widgets. You can find them on the website [flutter.dev]
          /// They can all be customized and you can create your own widgets using these as a base.
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +

                /// This is the [MediaQuery.of] function. It is used to get information about the
                /// device that the app is running on. It is used to get the padding of the top of the
                /// device. To get the height of the device you can use [MediaQuery.of(context).size.height]
                /// or if you choose to go with the [get] package you can use [Get.height]
                (constraints.maxHeight - shrinkOffset) * 0.1,
          ),
          child: const Placeholder(
            color: kPrimary,
            fallbackHeight: 100,
          ),
        );
      },
      providerConfigs: _controller.provideConfigs,
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) {
            Auth.instance.populateUser(null, state.user);
            Get.offAllNamed(Routes.HOME);
          },
        ),
      ],
    );
  }
}

// ** I hope this helps you understand what everything means in this file. If you have any questions
// ** please ask me. I will be glad to help either of you.
