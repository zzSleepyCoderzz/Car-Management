import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//sign out
void signUserOut() async {
  await FirebaseAuth.instance.signOut();
}

class DefaultAppBar extends PreferredSize {
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  DefaultAppBar({
    super.key,
    this.actions,
    this.leading,
    this.centerTitle = true,
  }) : super(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: const Text('Tune Up Garage'),
            actions: const [
              IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
            ],
          ),
        );
}
