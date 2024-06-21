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
  final String title;

  DefaultAppBar({
    super.key,
    this.actions,
    this.leading,
    this.centerTitle = true,
    required this.title,
  }) : super(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: Text(title),
            actions:  [
              IconButton(onPressed: (){
                signUserOut();
              }, icon: const Icon(Icons.logout)),
            ],
          ),
        );
}

