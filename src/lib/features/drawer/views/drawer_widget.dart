import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/login.dart';

class MenuDrawerWidget extends StatelessWidget {
  const MenuDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {},
        child: Drawer(
            child: ListView(
                padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: const Text("Inventory Audit Demo",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0)),
              ),
              const MenuItem(
                title: "Home",
                icon: Icon(Icons.home),
                route: "/projects",
              ),
              const MenuItem(
                title: "Developer",
                icon: Icon(Icons.phone_iphone),
                route: "/dev",
              ),
              const MenuItem(
                title: "Replication",
                icon: Icon(Icons.sync),
                route: "/devReplicator",
              ),
              const MenuItem(
                title: "Logout",
                icon: Icon(Icons.logout),
                route: "/logout",
              ),
            ])));
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String route;
  final Icon icon;

  const MenuItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () {
        if (route == "/logout") {
          context.read<LoginBloc>().add(const LogoutSubmitted());
        } else {
          Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
        }
      },
    );
  }
}
