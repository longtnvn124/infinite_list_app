import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/comment_bloc.dart';
import 'package:flutter_application_1/events/comments_events.dart';
import 'package:flutter_application_1/infinite_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {``
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter new app',
        home: BlocProvider(
          create: (context) => CommentBLoc()..add(CommentFetchedEvent()),
          child: InfinteList(),
        ));
  }
}
