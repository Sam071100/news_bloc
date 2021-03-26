import 'dart:async';
import 'dart:convert';
import 'news_info.dart';
import 'package:http/http.dart' as http;

enum NewsAction { Fetch, Delete }

class NewsBLoc {
  final _stateStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get _newsSink => _stateStreamController.sink;
  Stream<List<Article>> get newsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;

  NewsBLoc() {
    _eventStream.listen((event) async {
      if (event == NewsAction.Fetch) {
        try {
          var news = await getNews();
          if (news != null) {
            _newsSink.add(news.articles);
          } else {
            _newsSink.addError('Something went Wrong');
          }
        } on Exception {
          _newsSink.addError('Something went Wrong');
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }

  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client.get(
          'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=c24bfeff472440cda35599efa7d6f60e');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return newsModel;
    }

    return newsModel;
  }
}
