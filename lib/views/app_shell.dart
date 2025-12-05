import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class AppShell extends StatelessWidget {
  final Widget body;
  final Widget title;
  final List<Widget>? actions;

  const AppShell({super.key, required this.body, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    Widget buildNavColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sandwich Shop', style: heading1),
                SizedBox(height: 8),
                Text('Fresh sandwiches', style: normalText),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/about');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Sign In / Sign Up'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/auth');
            },
          ),
        ],
      );
    }

    // Small screens: use AppBar + Drawer
    if (width < 800) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                height: 32,
                child: Image.asset(
                  'assets/images/logo.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.fastfood, size: 32);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: title),
            ],
          ),
          actions: actions,
        ),
        drawer: Drawer(child: buildNavColumn()),
        body: body,
      );
    }

    // Wide screens: permanent side navigation
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 240,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: SafeArea(child: buildNavColumn()),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(height: 100, child: Image.asset('assets/images/logo.png')),
                ),
                title: title,
                actions: actions,
              ),
              body: body,
            ),
          ),
        ],
      ),
    );
  }
}
