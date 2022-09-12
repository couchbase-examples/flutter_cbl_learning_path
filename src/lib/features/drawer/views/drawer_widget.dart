import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import '../../login/login.dart';
import '../user_profile_ui.dart';

enum MenuRoute { logout, developer, replicator, projects }

class MenuDrawerWidget extends StatelessWidget {
  final AppRouterService routerService;
  const MenuDrawerWidget({super.key, required this.routerService});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
            children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: /*const Text("Inventory Audit Demo",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0)),
                    */
                const UserProfile(),
          ),
          MenuItem(
              title: "Home",
              icon: const Icon(Icons.home),
              route: MenuRoute.projects,
              routerService: routerService),
          MenuItem(
              title: "Developer",
              icon: const Icon(Icons.phone_iphone),
              route: MenuRoute.developer,
              routerService: routerService),
          MenuItem(
              title: "Replication",
              icon: const Icon(Icons.sync),
              route: MenuRoute.replicator,
              routerService: routerService),
          MenuItem(
              title: "Logout",
              icon: const Icon(Icons.logout),
              route: MenuRoute.logout,
              routerService: routerService),
        ]));
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final MenuRoute route;
  final Icon icon;
  final RouterService routerService;

  const MenuItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.route,
      required this.routerService});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () {
        switch (route) {
          case MenuRoute.logout:
            context.read<LoginBloc>().add(const LogoutSubmitted());
            break;
          case MenuRoute.developer:
            routerService.routeTo(RouteToScreen.developer);
            break;
          case MenuRoute.replicator:
            routerService.routeTo(RouteToScreen.replicator);
            break;
          case MenuRoute.projects:
            routerService.routeTo(RouteToScreen.projects);
            break;
        }
      },
    );
  }
}
