import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/comment_bloc.dart';
import 'package:flutter_application_1/events/comments_events.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/states/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class InfinteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfinteList();
}

class _InfinteList extends State<InfinteList> {
  final _scrollController = ScrollController();
  final _scrollThreadhold = 250.0;

  @override
  void initState() {
    CommentBLoc _commentBloc;
    // TODO: implement initState
    super.initState();
    _commentBloc = BlocProvider.of(context);
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final CurrenScroll = _scrollController.position.pixels;
      if (maxScrollExtent - CurrenScroll <= _scrollThreadhold) {
        _commentBloc.add(CommentFetchedEvent());
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<CommentBLoc, CommentState>(
        builder: (context, state) {
          if (state is CommentStateInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CommentStateFailure) {
            return Center(
                child: Text(
              'cannot load comments for server',
              style: TextStyle(fontSize: 22, color: Colors.red),
            ));
          }
          if (state is CommentStateSuccess) {
            final currentState = state as CommentStateSuccess;
            if (currentState.comments.isEmpty) {
              return Center(
                child: Text('Empty comments!'),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext buildContext, int index) {
                return ListTile(
                  leading: Text('${state.comments[index].id}'),
                  title: Text(
                    '${state.comments[index].email}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${state.comments[index].body}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  isThreeLine: true,
                );
              },
              itemCount: state.hasReachedEnd
                  ? state.comments.length
                  : state.comments.length + 1,
              controller: _scrollController,
            );
          }
          return Center(child: Text('Other states..'));
        },
      )),
    );
  }
}
