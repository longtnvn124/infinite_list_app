import 'package:flutter_application_1/events/comments_events.dart';
import 'package:flutter_application_1/models/comment.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/states/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBLoc extends Bloc<CommentEvent, CommentState> {
  final NUMBER_OF_COMMENT_PER_PAGE = 20;

  @override
  CommentBLoc() : super(CommentStateInitial());
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is CommentFetchedEvent &&
        !(state is CommentStateSuccess &&
            (state as CommentStateSuccess).hasReachedEnd)) {
      try {
        //Check if "has reached end of a page"
        if (state is CommentStateInitial) {
          //first time loading page
          //1.get comments from API
          //2.yield CommentStateSuccess
          final comments =
              await getCommentsFromApi(0, NUMBER_OF_COMMENT_PER_PAGE);
          yield CommentStateSuccess(comments: comments, hasReachedEnd: false);
        } else if (state is CommentStateSuccess) {
          //load next page
          //if "next page is empty" => yield "CommentStateSuccess" with hasReachedEnd = true
          final currentState = state as CommentStateSuccess;
          int finalIndexOfCurrentPage = currentState.comments.length;
          final comments = await getCommentsFromApi(
              finalIndexOfCurrentPage, NUMBER_OF_COMMENT_PER_PAGE);
          if (comments.isEmpty) {
            //change current state !
            yield currentState.cloneWith(hasReachedEnd: true);
          } else {
            //not empty, means "not reached end",
            yield CommentStateSuccess(
                comments: currentState.comments + comments, //merge 2 arrays
                hasReachedEnd: false);
          }
        }
      } catch (exception) {
        yield CommentStateFailure();
      }
    }
  }
}
