import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_rive_player/utils/util.dart';

import '../player/player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              ImageUtil.filePick(
                type: FileType.any,
              ).then((value) {
                if (value != null && value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(
                        file: value,
                      ),
                    ),
                  );
                } else {
                  showCupertinoDialog(
                      context: context,
                      builder: (ctx) {
                        return CupertinoAlertDialog(
                          content: Text("Please Select a file"),
                          actions: [
                            CupertinoButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        );
                      });
                }
              });
            },
            child: const Card(
              child: Center(
                child: Text(
                  "Click here to pick file",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
