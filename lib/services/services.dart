import 'dart:async';
import 'dart:convert';
import 'dart:html';
import '../infinite_list.dart';

import 'package:http/http.dart' as http;
import '../models/comment.dart';

Future<List<Comment>> getCommentsFromApi(int start, int limit) async {
  final url =
      "https://jsonplaceholder.typicode.com/comments?_start=$start&_limit=$limit";
  final http.Client httpClient = http.Client();

  try {
    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      //convert responseData to List of comment ?
      final List<Comment> comments = responseData.map((comment) {
        return Comment(
            id: comment['id'],
            name: comment['name'],
            email: comment['email'],
            body: comment['body']);
      }).toList();
      print('start = $start, limit = $limit');
      return comments;
    } else {
      List<Comment> comments = [];
      return comments;
    }
  } catch (exception) {
    List<Comment> comments = [];
    print('Exception sending api : ' + exception.toString());
    return comments;
  }
}
